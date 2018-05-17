class BarincrementdefsController < ApplicationController

  before_action :set_barincrementdef, only: [:show, :edit, :update, :destroy]
  def index
    @barincrementdefs = Barincrementdef.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

  def edit

  end

  def new
    @barincrementdef = Barincrementdef.new
  end

  def create
    @barincrementdef = Barincrementdef.new(barincrementdef_params)
    respond_to do |format|
      if @barincrementdef.save
        format.html { redirect_to barincrementdefs_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @barincrementdef.update(barincrementdef_params)
        format.html { redirect_to barincrementdefs_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @barincrementdef }
      else
        format.html { render :edit }
        format.json { render json: @barincrementdef.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @barincrementdef.destroy
    respond_to do |format|
      format.html { redirect_to barincrementdefs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_barincrementdef
    @barincrementdef = Barincrementdef.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def barincrementdef_params
    params.require(:barincrementdef).permit(:name, :summary)
  end

end
