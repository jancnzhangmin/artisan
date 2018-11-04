class WxpaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def pay
    fee = params[:price]
    if params[:couponnumber].to_s !=''
      fee = fee.to_f - params[:facevalue].to_f
    end
    artisanid = params[:artisanid]
    bartaskid = params[:bartaskid]
    ordernumber = Bartask.find(bartaskid).ordernumber
    userid = User.find_by_openid(params[:openid]).id
    userpayorder = Userpayorder.find_by_ordernumber(ordernumber)
    if userpayorder
      userpayorder.destroy
    end
    Userpayorder.create(artisanuser_id:artisanid,user_id:userid,bartask_id:bartaskid,price:fee,status:0,ordernumber:ordernumber,couponnumber:params[:couponnumber])
    payment_params = {
        body: "预支付服务费",
        out_trade_no: ordernumber,
        total_fee: (fee.to_f * 100).to_i,
        spbill_create_ip:  '127.0.0.1',
        notify_url: 'http://artisan.ysdsoft.com/wxpayments/notify',
        trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
        openid: params[:openid]  # required when trade_type is `JSAPI`
    }
    @result = WxPay::Service.invoke_unifiedorder(payment_params)
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    @sign_package = $client.get_jssign_package(request.url)

    if @result.nil?
      #render html: "no"
    else
      #render html: "#{@result.to_s},#{params.to_s}" if @result['return_code']=='FAIL'
      @pay_ticket_param = {
          timeStamp: @sign_package["timestamp"],
          nonceStr: @sign_package["nonceStr"],
          package: "prepay_id=#{@result['prepay_id']}",  #这里一定注意，不仅仅是prepay_id，还需要拼接上“prepay_id=”
          signType: "MD5",
          appId: WxPay.appid,
          key: WxPay.key
      }
      @pay_ticket_param = {
          paySign: WxPay::Sign.generate(@pay_ticket_param)  #然后我们手动进行paySign计算
      }.merge(@pay_ticket_param)
    end


    render json: params[:callback]+'({"pay_ticket_param":' + @pay_ticket_param.to_json + ',"sign_packge":'+@sign_package.to_json+'})',content_type: "application/javascript"
  end

  def notify
    result = Hash.from_xml(request.body.read)["xml"]
    if result['return_code']=='SUCCESS'
      ordernumber = result['out_trade_no']
      userpayorder = Userpayorder.find_by_ordernumber(ordernumber)
      if userpayorder.couponnumber.to_s != ''
        coupon = Coupon.find_by_couponnumber(userpayorder.couponnumber)
        coupon.alreadyused = 1
        coupon.ordernumber = ordernumber
        coupon.save
        Profit.create(ordernumber:ordernumber,amount:-coupon.facevalue,summary:'优惠券抵用')
      end
      userpayorder.status = 1
      userpayorder.save
      bartask = Bartask.find_by_ordernumber(ordernumber)
      bartask.status = 2
      bartask.save
      Testlog.create(log:ordernumber)
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    end
  end

end
