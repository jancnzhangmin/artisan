class UsersController < ApplicationController

  def index
      @users = User.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

end
