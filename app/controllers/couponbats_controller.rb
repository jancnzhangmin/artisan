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
    min = couponbat_params[:digit].to_i
    temmax = couponbat_params[:prefix].ljust(min,'9')
    min = couponbat_params[:prefix].ljust(min,'0')
    min = checkmin(min.to_i,temmax.to_i) - 1
    max = min + couponbat_params[:number].to_i - 1
    if max > temmax.to_i
      max = temmax.to_i
    end
    thcount = (max - min) / 100
    if ((max - min) % 100) > 0
      thcount += 1
    end

    loopcount = 100
    if (max - min) < 100
      loopcount = (max - min) + 1
    end

    ######券号最大值#######
    maxcoupon_number = max.to_s
    ######券号最大值END#######

    thcount.times do |i|
      temstep = i * 100
      temcouponarr = Array.new
      loopcount.times do
        temstep += 1
        temstr = (min + temstep).to_s
        if temstr.to_i <= maxcoupon_number.to_i
          temcouponarr.push temstr
        end
      end
      temcouponnumberarr = Array.new
      temcoupon_couponnumbers = Coupon.where('couponnumber in (?)',temcouponarr)
      temcoupon_couponnumbers.each do |f|
        temcouponnumberarr.push f.couponnumber
      end
      coupbat_model = 1
      if couponbat_params[:coupontype] == 3
        coupbat_model = 2
      end
      Coupon.transaction do
        step = i * 100

        #sqlstr = 'INSERT INTO coupons(model, facevalue,condition,expirytype,assignexpiry,fixedexpiry,alreadyused,name,couponnumber,summary,status,coupontype,city,couponbat_id) values'
        #sqlvalue = ''
        loopcount.times do
          step += 1
          progress = (step.to_f / (max - min)) * 100.0
          $redis.set("progress", progress)
          str = (min + step).to_s
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
            # sqlvalue += '('
            # sqlvalue += couponbat_params[:facevalue] +','
            # sqlvalue += couponbat_params[:condition] +','
            # sqlvalue += couponbat_params[:expirytype] +','
            # sqlvalue += couponbat_params[:assignexpiry] +','
            # sqlvalue += couponbat_params[:fixedexpiry] +','
            # sqlvalue += '0,'
            # sqlvalue += couponbat_params[:name] +','
            # sqlvalue += str +','
            # sqlvalue += couponbat_params[:summary] +','
            # sqlvalue += '1,'
            # sqlvalue += couponbat_params[:coupontype] +','
            # sqlvalue += couponbat_params[:city]
            # sqlvalue += couponbat.id.to_s
            # sqlvalue += '),'
          end
        end
        #sqlstr += sqlvalue.chop!
        #Coupon.find_by_sql(sqlstr)

      end
    end
    couponbat.numbegin = couponbat.coupons.first.couponnumber
    couponbat.numend = couponbat.coupons.last.couponnumber
    couponbat.number = couponbat.coupons.count
    couponbat.save
    $redis.set("progress", 0)
    $redis.set("progressstep", 0)
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
      if f.user_id.to_s != '' || f.artisanuser_id.to_s != '' || f.alreadyused == 0
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
    $redis.set("progress", 0)
    $redis.set("progressstep", 0)
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

  def checkmin(min,max) #递归可用起始couponnumber
    keyid = (max - min) / 2
    if keyid < 1
      return max
    else
      keyid += min
      coupon = Coupon.find_by_couponnumber(keyid)
      if coupon
        checkmin(keyid,max)
      else
        checkmin(min,keyid)
      end
    end
  end

  def createcoupon(couponbat,model,facevalue,condition,expirytype,assignexpiry,fixedexpiry,name,couponnumber,summary,coupontype,city)

  end

end
