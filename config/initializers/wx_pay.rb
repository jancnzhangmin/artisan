WxPay.appid = 'wxb3d1ca1df413ce9d'
WxPay.key = '59c1fe172e794e72a3bb6ec1c0d66fff'
WxPay.mch_id = '1489879452'
WxPay.debug_mode = true # default is `true`
WxPay.appsecret = 'c4a1d6d2a1b5af73a6666e1308e61595'
#WxPay.set_apiclient_by_pkcs12(File.read('/home/cert/posan/apiclient_cert.p12'), '1489879452')

WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}