class CouponbatsController < ApplicationController

  before_action :set_couponbat, only: [:show, :edit, :update, :destroy]
  def index
    @couponbats = Couponbat.all
  end

  def edit

  end

  def new
    @couponbat = Couponbat.new
    @citys = Chinadistrict.where('code like ? and code not like ?',"%#{'____00'}%","%#{'0000'}%")
  end

  def create

    couponbat = Couponbat.create(name:couponbat_params[:name],
                                  number:couponbat_params[:number],
                                  facevalue:couponbat_params[:facevalue],
                                  condition:couponbat_params[:condition],
                                  expirytype:couponbat_params[:expirytype],
                                  assignexpiry:couponbat_params[:assignexpiry],
                                  fixedexpiry:couponbat_params[:fixedexpiry],
                                  coupontype:couponbat_params[:coupontype],
                                  summary:couponbat_params[:summary],
                                  city:couponbat_params[:city]
    )


    $redis.set("progress", 0)
    $redis.set("progressstep", 0)
    thcount = couponbat_params[:number].to_i / 1000
    if (couponbat_params[:number].to_i % 1000) > 0
      thcount += 1
    end

    ######券号最大值#######
    #maxcoupon_number = couponbat_params[:prefix]
    le = couponbat_params[:digit].to_s.length - couponbat_params[:prefix].to_s.length - couponbat_params[:number].to_s.length
    lestr = ''
    le.times do
      lestr += '0'
    end
    maxcoupon_number = couponbat_params[:prefix].to_s + lestr + couponbat_params[:number].to_s

    ######券号最大值END#######

    tharr = Array.new
    thcount.times do |i|

      temstep = i * 1000

      #mutex.synchronize do


      #end
      temcouponarr = Array.new
      1000.times do
        temstep += 1

        temstr = couponbat_params[:prefix].to_s
        temlength = couponbat_params[:digit].to_i - temstr.length - temstep.to_s.length
        temlength.times do
          temstr += '0'
        end
        temstr += temstep.to_s
        if temstr.to_i <= maxcoupon_number.to_i
          temcouponarr.push temstr
        end
      end

      temcouponnumberarr = Array.new
      temcoupon_couponnumbers = Coupon.where('couponnumber in (?)',temcouponarr)
      temcoupon_couponnumbers.each do |f|
        temcouponnumberarr.push f.couponnumber
      end
      temcoupon_couponnumbers = nil

      coupbat_model = 1
      if couponbat_params[:coupontype] == 3
        coupbat_model = 2
      end
      Coupon.transaction do
        step = i * 1000
        1000.times do
          step += 1
          progress = (step.to_f / couponbat_params[:number].to_f) * 100.0
          $redis.set("progress", progress)
          str = couponbat_params[:prefix].to_s
          temlength = couponbat_params[:digit].to_i - str.length - step.to_s.length
          temlength.times do
            str += '0'
          end
          str += step.to_s
          if temcouponnumberarr.count(str) == 0
            couponbat.coupons.create(model:coupbat_model,
                                      facevalue:couponbat_params[:facevalue],
                                      condition:couponbat_params[:condition],
                                      expirytype:couponbat_params[:expirytype],
                                      assignexpiry:couponbat_params[:assignexpiry],
                                      fixedexpiry:couponbat_params[:fixedexpiry],
                                      alreadyused:0,
                                      name:couponbat_params[:name],
                                      couponnumber:str,
                                      summary:couponbat_params[:summary],
                                      status:1,
                                      coupontype:couponbat_params[:coupontype],
                                      city:couponbat_params[:city]
            )
          end
        end
      end
      temcouponnumberarr.clear


    end
    couponbat.numbegin = couponbat.coupons.minimum('couponnumber')
    couponbat.numend = couponbat.coupons.maximum('couponnumber')
    couponbat.number = couponbat.coupons.count
    couponbat.save




    # str = ''
    # numbegin = ''
    # step = 0
    # $redis.set("progress", 0)
    # Coupon.transaction do
    #
    #   temstr = ''
    #   temstep = 0
    #   temcouponarr = Array.new
    #   couponbat_params[:number].to_i.times do
    #     temstr = couponbat_params[:prefix].to_s
    #     temlength = couponbat_params[:digit].to_i - temstr.length - temstep.to_s.length
    #     temlength.times do
    #       str = str + '0'
    #     end
    #     temstr = temstr + temstep.to_s
    #     temcouponarr.push temstr
    #   end
    #
    #   temcouponnumberarr = Array.new
    #   temcoupon_couponnumbers = Coupon.where('couponnumber in (?)',temcouponarr)
    #   temcoupon_couponnumbers.each do |f|
    #     temcouponnumberarr.push f.couponnumber
    #   end
    #
    #   couponbat_params[:number].to_i.times do
    #     step = step + 1
    #     progress = (step.to_f / couponbat_params[:number].to_f) * 100.0
    #     $redis.set("progress", progress)
    #     str = couponbat_params[:prefix].to_s
    #     temlength = couponbat_params[:digit].to_i - str.length - step.to_s.length
    #     temlength.times do
    #       str = str + '0'
    #     end
    #     str = str + step.to_s
    #
    #     if numbegin == ''
    #       numbegin = str
    #     end
    #
    #     coupbat_model = 1
    #     if couponbat_params[:coupontype] == 3
    #       coupbat_model = 2
    #     end
    #
    #     #coupon = Coupon.find_by_couponnumber(str)
    #
    #     if temcouponnumberarr.count(str) == 0
    #       @couponbat.coupons.create(model:coupbat_model,
    #                                 facevalue:couponbat_params[:facevalue],
    #                                 condition:couponbat_params[:condition],
    #                                 expirytype:couponbat_params[:expirytype],
    #                                 assignexpiry:couponbat_params[:assignexpiry],
    #                                 fixedexpiry:couponbat_params[:fixedexpiry],
    #                                 alreadyused:0,
    #                                 name:couponbat_params[:name],
    #                                 couponnumber:str,
    #                                 summary:couponbat_params[:summary],
    #                                 status:1,
    #                                 coupontype:couponbat_params[:coupontype],
    #                                 city:couponbat_params[:city]
    #       )
    #     end
    #   end
    # end
    # @couponbat.numbegin = numbegin
    # @couponbat.numend = str
    # @couponbat.number = @couponbat.coupons.count
    # @couponbat.save

    redirect_to couponbats_path
  end

  def getprogress
    progress = $redis.get("progress")
    render json:progress.to_s
  end

  def update
    respond_to do |format|
      if @couponbat.update(couponbat_params)
        format.html { redirect_to couponbats_path, notice: 'Couponbat was successfully updated.' }
        format.json { render :show, status: :ok, location: @couponbat }
      else
        format.html { render :edit }
        format.json { render json: @couponbat.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    $redis.set("progress", 0)
    notice = '删除成功'
    coupons = @couponbat.coupons
    delcouponids = Array.new
    coupons.each do |f|
      if f.user_id.to_s == '' && f.artisanuser_id.to_s == '' && f.alreadyused == 0
        delcouponids.push f.id
      end
    end
    #Coupon.destroy(delcouponids) unless delcouponids.blank?
    cstep = 0
    stepcount = delcouponids.count
    delcouponids.each do |f|
      Coupon.delete(f)
      cstep = cstep + 1
      progress = (cstep.to_f / stepcount.to_f) * 100.0
      $redis.set("progress", progress)
    end

    if @couponbat.coupons.count == 0
      @couponbat.destroy
    else
      @couponbat.number = @couponbat.coupons.count
      @couponbat.save
      notice = '批量卡下存在已使用或已绑定用户的卡，无法全部删除'
    end
    respond_to do |format|
      format.html { redirect_to couponbats_path, notice: notice }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_couponbat
    @couponbat = Couponbat.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def couponbat_params
    params.require(:couponbat).permit(:name, :number, :facevalue, :condition, :expirytype, :assignexpiry, :fixedexpiry, :coupontype, :summary, :generate, :numbegin, :numend, :city, :prefix, :digit)
  end

end
