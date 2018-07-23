class OrdercountsController < ApplicationController
  def index
    @bartasks = Bartask.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
    if params[:province].to_s != ''
      province = Chinadistrict.find_by_code(params[:province]).address
      @bartasks = @bartasks.where('province like ?',"%#{province}%")
    end
    if params[:city].to_s != ''
      city = Chinadistrict.find_by_code(params[:city]).address
      @bartasks = @bartasks.where('city like ?',"%#{city}%")
    end
    if params[:district].to_s != ''
      district = Chinadistrict.find_by_code(params[:district]).address
      @bartasks = @bartasks.where('district like ?',"%#{district}%")
    end
  end

  def getprovince
    provinces = Chinadistrict.where('code like ?',"%#{'0000'}%")
    render json:provinces.to_json
  end

  def getcity
    citys = Chinadistrict.where('code like ? and code <> ?',"%#{ + params[:code][0,2] + '__00'}%",params[:code])
    render json:citys.to_json
  end

  def getdistrict
    districts = Chinadistrict.where('code like ? and code <> ?',"%#{ + params[:code][0,4] + '__'}%",params[:code])
    render json:districts.to_json
  end

end
