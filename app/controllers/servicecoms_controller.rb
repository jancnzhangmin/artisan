class ServicecomsController < ApplicationController

  def index
    servicecom = Servicecom.first
    redirect_to edit_servicecom_path(servicecom)
  end

  def edit
    @servicecom = Servicecom.first
  end

  def update
    @servicecom = Servicecom.first
    @servicecom.update(servicecom_params)
    @status = '数据保存成功'
  end

  private
  def servicecom_params
    params.require(:servicecom).permit(:base, :percent)
  end

end
