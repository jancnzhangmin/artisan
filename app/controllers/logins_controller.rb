class LoginsController < ApplicationController

  def index

  end

  def create
    @status = ''

    admin = Admin.find_by(login:params[:login][:login])
    if verify_rucaptcha?(admin)
      if admin && admin.authenticate(params[:login][:password])
        if admin.status == 0
          @status = "用户已停用，请联系管理员！"
        else
          session[:userid] = admin.id
          session[:username] = admin.name
          redirect_to ordercounts_path

        end
      else
        @status = "用户名或密码无效！"
      end
    else
      @status = "验证码无效！"

    end

  end

end
