class AdminsController < ApplicationController

  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  def index
    @admins = Admin.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

  def edit

  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    respond_to do |format|
      if @admin.save
        format.html { redirect_to admins_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to admins_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  def checkuser
    status = true
    admin = Admin.find_by_login(params[:admin][:login])
    if admin
      status = false
    end
    render json:status
  end

  def auth
    @admin = Admin.find(params[:id])
    @roles = Role.all
    @adminroleids = @admin.roles.ids
  end

  def setauth
    @admin = Admin.find(params[:id])
    roles = @admin.roles
    roles.delete_all
    params[:auth].split(',').each do |f|
      role = Role.find(f)
      if role
        @admin.roles << role
      end
    end
    redirect_to admins_path

  end


  private
# Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:name, :login, :password, :password_confirmation, :status)
  end

end
