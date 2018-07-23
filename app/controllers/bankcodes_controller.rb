class BankcodesController < ApplicationController

  before_action :set_bankcode, only: [:show, :edit, :update, :destroy]
  def index
    @bankcodes = Bankcode.all
  end

  def edit

  end

  def new
    @bankcode = Bankcode.new
  end

  def create
    @bankcode = Bankcode.new(bankcode_params)
    respond_to do |format|
      if @bankcode.save
        format.html { redirect_to bankcodes_path notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @bankcode.update(bankcode_params)
        format.html { redirect_to bankcodes_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @bankcode }
      else
        format.html { render :edit }
        format.json { render json: @bankcode.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @bankcode.destroy
    respond_to do |format|
      format.html { redirect_to bankcodes_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_bankcode
    @bankcode = Bankcode.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def bankcode_params
    params.require(:bankcode).permit(:bankcode, :bank)
  end

end
