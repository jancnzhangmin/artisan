class LocksController < ApplicationController

  before_action :set_lock, only: [:show, :edit, :update, :destroy]
  def index
    @locks = Lock.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

  def edit

  end

  def new
    @lock = Lock.new
  end

  def create
    @lock = Lock.new(lock_params)
    respond_to do |format|
      if @lock.save
        format.html { redirect_to locks_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @lock.update(lock_params)
        format.html { redirect_to locks_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @lock }
      else
        format.html { render :edit }
        format.json { render json: @lock.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @lock.destroy
    respond_to do |format|
      format.html { redirect_to locks_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_lock
    @lock = Lock.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def lock_params
    params.require(:lock).permit(:lock)
  end

end
