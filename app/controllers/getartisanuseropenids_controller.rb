class GetartisanuseropenidsController < ApplicationController

  def getopenid
    code=params[:code]
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    # conn.headers[:apikey] = '6e1802f8c0cd1b42b32249ba42c2e602'
    conn.params[:appid]='wxb3d1ca1df413ce9d'
    conn.params[:secret]='c4a1d6d2a1b5af73a6666e1308e61595'
    conn.params[:code]=params[:code]
    conn.params[:grant_type]='authorization_code'
    request = conn.get do |req|
      req.url '/sns/oauth2/access_token'
    end
    #return request.body

    #//////////////////////////////////////////////////////////
    #location = getip(params[:ip])
    accessjson = request.body.to_json
    Testlog.create(log:accessjson)
    accesstoken=accessjson['access_token']
    openid=accessjson['openid']
    refreshtoken=accessjson['REFRESH_TOKEN']

    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    # conn.headers[:apikey] = '6e1802f8c0cd1b42b32249ba42c2e602'
    conn.params[:access_token]=accesstoken
    conn.params[:openid]=openid
    conn.params[:lang]='zh_CN'
    request = conn.get do |req|
      req.url '/sns/userinfo'
    end

    userinfojson=request.body.to_json


    render json: params[:callback]+'({"access_token":' + accessjson + '})',content_type: "application/javascript"
  end

end
