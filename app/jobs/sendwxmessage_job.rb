class SendwxmessageJob < ApplicationJob
  queue_as :default

  def perform(touser,template_id,url,data)
    # Do something later
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    $client.send_template_msg(touser, template_id, url,'#173177', data)
  end
end
