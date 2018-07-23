class BarbasedefsController < ApplicationController

  before_action :set_barbasedef, only: [:show, :edit, :update, :destroy]
  def index
    @barbasedefs = Barbasedef.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

  def edit

  end

  def new
    @barbasedef = Barbasedef.new
  end

  def create
    @barbasedef = Barbasedef.new(barbasedef_params)
    respond_to do |format|
      if @barbasedef.save
        format.html { redirect_to barbasedefs_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @barbasedef.update(barbasedef_params)
        format.html { redirect_to barbasedefs_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @barbasedef }
      else
        format.html { render :edit }
        format.json { render json: @barbasedef.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @barbasedef.destroy
    respond_to do |format|
      format.html { redirect_to barbasedefs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_barbasedef
    @barbasedef = Barbasedef.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def barbasedef_params
    params.require(:barbasedef).permit(:name, :summary)
  end

end
