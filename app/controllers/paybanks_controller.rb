class PaybanksController < ApplicationController
  def payuser
    status = 0
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    tradeno = Time.now.strftime('%Y%m%d%H%M%S') + artisanuser.id.to_s
    bankcard = Bankcard.find(params[:bankcardid])
    bankcode = Bankcode.find(bankcard.bankcode_id)
    payparams = {
        partner_trade_no:tradeno,
        enc_bank_no:hpd_rsa_encode_by_string(bankcard.cardnumber),
        enc_true_name:hpd_rsa_encode_by_string(bankcard.name),
        bank_code:bankcode.bankcode,
        amount:(params[:amount].to_f * 100).to_i,
        desc:'刘叔叔装门平台提现'
    }
    result = WxPay::Service.pay_bank(payparams)
    if result['err_code'] == 'SUCCESS'
      withdraws = artisanuser.widthdraws
      withdraws.create(amount:params[:amount], bankname:bankcard.name, cardnumber:bankcard.cardnumber, bank:bankcode.bank, withdrawto:1, processstatus:0, tradeno:tradeno, summary:'处理中')
      status = 1
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  private

  def hpd_rsa_encode_by_string(data)
    $publickey ||= WxPay::Service.risk_get_public_key()
    public_key = $publickey['pub_key']
    public_key = OpenSSL::PKey::RSA.new(public_key)
    secret = public_key.public_encrypt_oaep(data)
    secret = Base64.encode64(secret).gsub!("\n",'')
    return secret
  end




end
