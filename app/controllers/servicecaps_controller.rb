class ServicecapsController < ApplicationController

  before_action :set_servicecap, only: [:show, :edit, :update, :destroy]
  def index
    @servicecaps = Servicecap.all
  end

  def edit

  end

  def new
    @servicecap = Servicecap.new
  end

  def create
    @servicecap = Servicecap.new(servicecap_params)
    respond_to do |format|
      if @servicecap.save
        format.html { redirect_to servicecaps_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @servicecap.update(servicecap_params)
        format.html { redirect_to servicecaps_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @servicecap }
      else
        format.html { render :edit }
        format.json { render json: @servicecap.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @servicecap.destroy
    respond_to do |format|
      format.html { redirect_to servicecaps_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_servicecap
    @servicecap = Servicecap.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def servicecap_params
    params.require(:servicecap).permit(:servicecap)
  end

end
