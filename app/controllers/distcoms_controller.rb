class DistcomsController < ApplicationController

  def index
    distcom = Distcom.first
    redirect_to edit_distcom_path(distcom)
  end

  def edit
    @distcom = Distcom.first
  end

  def update
    @distcom = Distcom.first
    @distcom.update(distcom_params)
    @status = '数据保存成功'
  end

  private
  def distcom_params
    params.require(:distcom).permit(:distcom)
  end

end
