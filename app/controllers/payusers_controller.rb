class PayusersController < ApplicationController
  def index

  end

  def pay
    nonce=SecureRandom.uuid.tr('-', '')
    #tradeno = Time.now.strftime('%Y%m%d%H%M%S') + artisanuser.id.to_s
    payment_params={
        nonce_str:nonce,
        partner_trade_no:'20181102001',
        openid:'opN8uxEts2tNZpp2U8Nm8V_ecV1c',
        check_name:'NO_CHECK',
        amount:4000,
        desc:'刘叔叔装门平台提现',
        spbill_create_ip:'127.0.0.1'
    }
    @result = WxPay::Service.invoke_transfer(payment_params)
    render json: @result
  end

end
