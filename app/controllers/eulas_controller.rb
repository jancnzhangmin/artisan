class EulasController < ApplicationController

  before_action :set_eula, only: [:show, :edit, :update, :destroy]
  def index
    @eula = Eula.first
    if !@eula
      @eula = Eula.create()
    end
    redirect_to edit_eula_path @eula
  end

  def edit

  end


  def update
    respond_to do |format|
      if @eula.update(eula_params)
        format.html { redirect_to edit_eula_path @eula, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @eula }
      else
        format.html { render :edit }
        format.json { render json: @eula.errors, status: :unprocessable_entity }
      end
    end
  end




  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_eula
    @eula = Eula.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def eula_params
    params.require(:eula).permit(:tile, :eula)
  end

end
