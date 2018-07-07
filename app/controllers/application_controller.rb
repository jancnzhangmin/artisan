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

  private
  def hmac_sha1(data, secret)
    require 'base64'
    require 'cgi'
    require 'openssl'
    hmac = CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1',secret, data)}").chomp)
    return hmac
  end

  def randnumber
    vcode=''
    6.times do
      vcode+=rand(10).to_s
    end
    return vcode
  end

end
