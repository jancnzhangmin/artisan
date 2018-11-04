class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def getevent
    #render json: params[:echostr].to_s
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    result = Hash.from_xml(request.body.read)["xml"]
    Testlog.create(log:result)
    user_info = $client.user(result['FromUserName'])

    artisanuser = Artisanuser.find_by_openid(result['FromUserName'])
    user = User.find_by_openid(result['FromUserName'])
    if result['Event'] == 'subscribe'
      usertype = result['EventKey'][8]
      if usertype == '1'
        if !artisanuser
          Artisanuser.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,up_id:result['EventKey'][9,result['EventKey'].length].to_i)
        end
        if !user
          User.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,artisanuser_id:result['EventKey'][9,result['EventKey'].length].to_i)
        end
      elsif usertype == '2'
        if !user
          User.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,up_id:result['EventKey'][9,result['EventKey'].length].to_i)
        end
        if !artisanuser
          Artisanuser.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,user_id:result['EventKey'][9,result['EventKey'].length].to_i)
        end
      end
    elsif result['Event'] == 'SCAN'
      if !artisanuser
        usertype = result['EventKey'][0]
        if usertype == '1'
          if !artisanuser
            Artisanuser.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,up_id:result['EventKey'][1,result['EventKey'.length]].to_i)
          end
          if !user
            User.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,artisanuser_id:result['EventKey'][1,result['EventKey'].length].to_i)
          end
        elsif usertype == '2'
          if !user
            User.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,up_id:result['EventKey'][1,result['EventKey'].length].to_i)
          end
          if !artisanuser
            Artisanuser.create(openid:result['FromUserName'],headurl:user_info.result['headimgurl'],status:1,user_id:result['EventKey'][1,result['EventKey'].length].to_i)
          end
        end
      end
    end
    render json:'SUCCESS'
  end

  def index

  end

  def getqrcode
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    ticket = $client.create_qr_scene(params[:id]).result['ticket']
    qr = $client.qr_code_url(ticket)
    redirect_to qr
  end

end
