class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require 'net/http'
  def sendvcode(phone,vcode)
    #phone=params[:phone]
    #vcode=randnumber
    require 'cgi'
    require 'digest/sha1'
    require 'base64'
    product = "Dysmsapi"
    domain = "dysmsapi.aliyuncs.com"
    accessKeyId = "LTAIAvikFGuaSwZc"
    accessKeySecret = "KgTGqXAGMS4NtSvlIkGrR03QW4bCQQ"
    codeparams={
        SignatureMethod:'HMAC-SHA1',
        SignatureNonce:SecureRandom.uuid,
        AccessKeyId:accessKeyId,
        SignatureVersion:'1.0',
        Timestamp:Time.now.gmtime.strftime('%Y-%m-%dT%H:%M:%SZ'),
        Format:'XML',

        Action:'SendSms',
        Version:'2017-05-25',
        RegionId:'cn-hangzhou',
        PhoneNumbers:phone,
        SignName:'刘叔叔',
        TemplateParam:"{\"code\":\""+vcode+"\"}" ,
        TemplateCode:'SMS_138066735'
    }

    codeparams = "#{codeparams.sort.map { |k, v| CGI.escape("#{k}")+'='+CGI.escape("#{v}") }.join('&')}"
    stringToSign = 'GET&'
    stringToSign += CGI.escape('/')+'&'
    stringToSign += CGI.escape(codeparams)
    hmac = hmac_sha1(stringToSign,accessKeySecret+'&')
    signature = CGI.escape(hmac)
    url = 'http://dysmsapi.aliyuncs.com/?Signature='+hmac+'&'+codeparams
    ret_data = Net::HTTP.get(URI.parse(url))
    #render json: params[:callback]+'({"status":"1"})',content_type: "application/javascript"
  end

  def sendwxsms(touser,template_id,url,data)
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    $client.send_template_msg(touser, template_id, url,'#173177', data)

  end

  def querybank(partnerno)
    params = {
        partner_trade_no:partnerno
    }
    withdraw = Widthdraw.find_by_tradeno(partnerno)
    if withdraw.processstatus < 1
      result = WxPay::Service.query_bank(params)
      if result['status'] == 'SUCCESS'
        withdraw.processstatus = 1
        withdraw.summary = '提现成功'
        withdraw.save
      elsif result['status'] == 'FAILED'
        withdraw.processstatus = 1
        withdraw.summary = '提现失败'
        withdraw.amount = -withdraw.amount
        withdraw.save
      elsif result['status'] == 'BANK_FAIL'
        withdraw.processstatus = 1
        withdraw.summary = '银行退票'
        withdraw.amount = -withdraw.amount
        withdraw.save
      end
    end

  end

  def artisanqrcodetran(artisanuserid)
    idlength = artisanuserid.to_s.length
    temid = artisanuserid.to_s
    (8 - idlength).times do
      temid = '0' + temid
    end
    temid = '1' + temid
    #前缀1技工 前缀2用户
    qrcode = RQRCode::QRCode.new("http://artisan.ysdsoft.com/events/getqrcode?id=" + temid)
    #qrcode = RQRCode::QRCode.new("http://192.168.1.102:3000/events/getqrcode?id=" + artisanuserid.to_s)
# With default options specified explicitly
    png = qrcode.as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        fill: 'white',
        color: '#2171ba',
        size: 200,
        border_modules: 0,
        module_px_size: 6,
        file: nil # path to write
    )
    IO.write(Rails.root.to_s + "/tmp/" + artisanuserid.to_s + ".png", png.to_s.force_encoding('utf-8'))
    img=Magick::Image.read(Rails.root.to_s + '/public/qrcodeback/qrcodeback.png').first
    img2 = Magick::Image.from_blob(png.to_s.force_encoding('utf-8')).first
    img.composite!(img2, 90,240, Magick::CopyCompositeOp)
    img.write(Rails.root.to_s + '/tmp/qrcode' + artisanuserid.to_s + '.png')
    artisanuser = Artisanuser.find(artisanuserid)
    if artisanuser
      file = File.open(Rails.root.to_s + '/tmp/qrcode' + artisanuserid.to_s + '.png')
      artisanuser.artisanuserqrcodeimg = file
      artisanuser.save
    end
    begin
      #File.delete(Rails.root.to_s + "/tmp/" + artisanuserid.to_s + ".png")
      #File.delete(Rails.root.to_s + '/tmp/qrcode' + artisanuserid.to_s + '.png')
    rescue

    end
  end

  def userqrcodetran(userid)
    idlength = userid.to_s.length
    temid = userid.to_s
    (8 - idlength).times do
      temid = '0' + temid
    end
    temid = '2' + temid
    #前缀1技工 前缀2用户
    qrcode = RQRCode::QRCode.new("http://artisan.ysdsoft.com/events/getqrcode?id=" + temid)
    #qrcode = RQRCode::QRCode.new("http://192.168.1.102:3000/events/getqrcode?id=" + artisanuserid.to_s)
    # With default options specified explicitly
    png = qrcode.as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        fill: 'white',
        color: '#2171ba',
        size: 200,
        border_modules: 0,
        module_px_size: 6,
        file: nil # path to write
    )
    IO.write(Rails.root.to_s + "/tmp/u" + userid.to_s + ".png", png.to_s.force_encoding('utf-8'))
    img=Magick::Image.read(Rails.root.to_s + '/public/qrcodeback/qrcodeback.png').first
    img2=Magick::Image.read(Rails.root.to_s + "/tmp/u" + userid.to_s + ".png").first #版权图片
    img.composite!(img2, 90,240, Magick::CopyCompositeOp)
    img.write(Rails.root.to_s + '/tmp/uqrcode' + userid.to_s + '.png')
    user = User.find(userid)
    if user
      file = File.open(Rails.root.to_s + '/tmp/uqrcode' + userid.to_s + '.png')
      user.userqrcodeimg = file
      user.save
    end
    begin
      File.delete(Rails.root.to_s + "/tmp/u" + userid.to_s + ".png")
      File.delete(Rails.root.to_s + '/tmp/uqrcode' + userid.to_s + '.png')
    rescue

    end
  end

  private
  def hmac_sha1(data, secret)
    require 'base64'
    require 'cgi'
    require 'openssl'
    hmac = CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1',secret, data)}").chomp)
    return hmac
  end


end
