class AllotusercouponsController < ApplicationController

  def index
    @couponbat = Couponbat.find(params[:couponbat_id])
    coupons = @couponbat.coupons.where('user_id is not null')
    userids = [0]
    coupons.each do |f|
      userids.push f.user_id
    end
    @alreadusers = User.where('id in (?) ',userids).paginate(:page => params[:page], :per_page => 10)
    @users = User.where('id not in (?)',userids).paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @couponbat = Couponbat.find(params[:couponbat_id])
    coupons = @couponbat.coupons.where('user_id is not null')
    userids = [0]
    coupons.each do |f|
      userids.push f.user_id
    end
    users = User.where('id not in (?)',userids)
    temusersid = Array.new
    users.each do |f|
      temusersid.push f.id
    end
    coupons = @couponbat.coupons.where('user_id is null')
    coupons.each do |f|
      if temusersid.count > 0
        f.user_id = temusersid[0]
        temusersid.delete(temusersid[0])
        f.save
      end
    end
    redirect_to couponbat_allotusercoupons_path(params[:couponbat_id])
  end

end
