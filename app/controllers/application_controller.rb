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
        TemplateCode:'SMS_89890129'
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
