class ProjectdefsController < ApplicationController

  before_action :set_projectdef, only: [:show, :edit, :update, :destroy]
  def index
    @projectdefs = Projectdef.all
  end

  def edit

  end

  def new
    @projectdef = Projectdef.new
  end

  def create
    @projectdef = Projectdef.new(projectdef_params)
    respond_to do |format|
      if @projectdef.save
        format.html { redirect_to projectdefs_path notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @projectdef.update(projectdef_params)
        format.html { redirect_to projectdefs_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @projectdef }
      else
        format.html { render :edit }
        format.json { render json: @projectdef.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @projectdef.destroy
    respond_to do |format|
      format.html { redirect_to projectdefs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_projectdef
    @projectdef = Projectdef.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def projectdef_params
    params.require(:projectdef).permit(:project)
  end

end
