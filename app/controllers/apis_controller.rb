class ApisController < ApplicationController
  skip_before_action :verify_authenticity_token
  def getproducts
    products = Product.all
    render json: params[:callback]+'({"products":'+ products.to_json + '})',content_type: "application/javascript"
  end

  def getprojectdefs
    projectdefs = Projectdef.all
    render json: params[:callback]+'({"projectdefs":'+ projectdefs.to_json + '})',content_type: "application/javascript"
  end

  def getlocks
    locks = Lock.all
    render json: params[:callback]+'({"locks":'+ locks.to_json + '})',content_type: "application/javascript"
  end

  def getbarbases
    barbases = Barbasedef.all
    render json: params[:callback]+'({"barbases":'+ barbases.to_json + '})',content_type: "application/javascript"
  end

  def getbarincrements
    increments = Barincrementdef.all
    render json: params[:callback]+'({"increments":'+ increments.to_json + '})',content_type: "application/javascript"
  end

  def setbartask
    user = User.find_by_openid(JSON.parse(params[:bartask])['rows'][0]['openid'])
    ordernumber = Time.now.strftime('%Y%m%d%H%M%S') + user.id.to_s

    hasordernumber = Bartask.find_by_ordernumber(ordernumber)
    if !hasordernumber
      bartask = user.bartasks.create(preprice:JSON.parse(params[:bartask])['rows'][0]['preprice'].to_f,
                                     province:JSON.parse(params[:bartask])['rows'][0]['province'],
                                     city:JSON.parse(params[:bartask])['rows'][0]['city'],
                                     district:JSON.parse(params[:bartask])['rows'][0]['district'],
                                     address:JSON.parse(params[:bartask])['rows'][0]['address'],
                                     status:1,
                                     installtime:JSON.parse(params[:bartask])['rows'][0]['installtime'],
                                     ordernumber:Time.now.strftime('%Y%m%d%H%M%S') + user.id.to_s,
                                     contact:JSON.parse(params[:bartask])['rows'][0]['contact'],
                                     contactphone:JSON.parse(params[:bartask])['rows'][0]['contactphone'],
                                     summary:JSON.parse(params[:bartask])['rows'][0]['summary'],
                                     paytype:JSON.parse(params[:bartask])['rows'][0]['paytype']
      )
      if JSON.parse(params[:measure])['rows'].count > 0
        JSON.parse(params[:measure])['rows'].each do |row|
          bartask.measures.create(doorset:row['doorset'],
                                  isfloorheat:row['isfloorheat'],
                                  idding:row['isding'],
                                  openinout:row['openinout'],
                                  openleftright:row['openleftright'],
                                  summary:row['summary']
          )
        end
      end
      if JSON.parse(params[:transit])['rows'].count > 0
        JSON.parse(params[:transit])['rows'].each do |row|
          bartask.transits.create(start:row['startprovince'].to_s + row['startcity'].to_s + row['startdistrict'].to_s + row['startaddress'].to_s,
                                  end:row['endprovince'].to_s + row['endcity'].to_s + row['enddistrict'].to_s + row['endaddress'].to_s
          )
        end
      end
      if JSON.parse(params[:bartaskdetail])['rows'].count > 0
        JSON.parse(params[:bartaskdetail])['rows'].each do |row|
          bartaskdetail = bartask.bartaskdetails.create(brand:row['brand'],product_id:row['product_id'],lock_id:row['lock_id'],projectdef_id:row['projectdef_id'])
          if row['productbaseid'].length > 0
            row['productbaseid'].each do |barbase|
              if barbase.to_s != ''
                bartaskdetail.barbasedefs << Barbasedef.find(barbase)
              end
            end
          end
          if row['productincrementid'].length > 0
            row['productincrementid'].each do |barincrement|
              if barincrement.to_s != ''
                bartaskdetail.barincrementdefs << Barincrementdef.find(barincrement)
              end
            end
          end
        end
      end

      if JSON.parse(params[:finger])['rows'].count > 0
        JSON.parse(params[:finger])['rows'].each do |row|
          bartask.fingers.create(model:row['model'],summary:row['summary'],fingermodeldef_id:row['fingermodeldef_id'])
        end
      end

      if JSON.parse(params[:openlock])['rows'].count > 0
        JSON.parse(params[:openlock])['rows'].each do |row|
          bartask.openlocks.create(summary:row['summary'])
        end
      end

      measurecount = bartask.measures.count
      fingercount = bartask.fingers.count
      transitcount = bartask.transits.count
      bartaskdetailcount = bartask.bartaskdetails.count
      openlockcount = bartask.openlocks.count
      #debugger
      servicetype = ''
      if measurecount > 0
        servicetype = servicetype + '测量'
      end
      if transitcount > 0
        servicetype = servicetype + '运输'
      end
      if bartaskdetailcount > 0
        servicetype = servicetype + '安装'
      end
      if openlockcount > 0
        servicetype = servicetype + '维修 开锁'
      end
      if fingercount > 0
        finger = bartask.fingers.first.fingermodeldef
        if finger
          servicetype = servicetype + finger.model
        end
      end


      data={
          "first": {
              "value":"您有新的订单",
              "color":"#173177"
          },
          "tradeDateTime":{
              "value":Time.now.strftime('%Y-%m-%d %H:%M:%S')
          },
          "orderType": {
              "value":servicetype
          },
          "customerInfo":{
              "value":bartask.province + bartask.city + bartask.district
          },
          "orderItemName":{
              "value":'服务时间'
          },
          "orderItemData":{
              "value":bartask.installtime.strftime('%Y-%m-%d')
          },
          "remark":{
              "value":''
          }
      }

      artisanusers = Artisanuser.all
      artisanusers.each do |artisanuser|
        #sendwxsms(artisanuser.openid,'ZP0GkSHfDhCEvlbQYl2t8A3JahxPB7ScyF_ZSzqOJm8','http://artisan.liushushu.com/getartisanuseropenids',data)
        SendwxmessageJob.perform_later(artisanuser.openid,'ZP0GkSHfDhCEvlbQYl2t8A3JahxPB7ScyF_ZSzqOJm8','http://artisan.ysdsoft.com/getartisanuseropenids',data)
      end
    end

    render json:'{"status":"200"}'

  end

  def setwxuserinfo
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    status = 0 #0用户已禁用 1正常用户 2具备管理权限
    user = User.find_by_openid(params[:openid])
    if user
      status = user.status
      if params[:openid].to_s != ''
        user_info = $client.user(params[:openid])
        result = user_info.result
        user.headurl = result['headimgurl']
        user.save
      end
    else
      if params[:openid].to_s != ''
        user_info = $client.user(params[:openid])
        result = user_info.result
        User.create(openid:params[:openid],headurl:result['headimgurl'],status:1)
        status = 1
      end
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def setwxartisaninfo
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    status = 0 #0用户已禁用 1正常用户 2具备管理权限
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    if artisanuser
      status = artisanuser.status
      if params[:openid].to_s != ''
        begin
          user_info = $client.user(params[:openid])
          result = user_info.result
          artisanuser.headurl = result['headimgurl']
          artisanuser.save
        rescue
        end
      end
    else
      if params[:openid].to_s != ''
        user_info = $client.user(params[:openid])
        result = user_info.result
        Artisanuser.create(openid:params[:openid],headurl:result['headimgurl'],status:1)
        status = 1
      end
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def getwxuserinfo
    user = User.find_by_openid(params[:openid])
    render json: params[:callback]+'({"user":'+ user.to_json + '})',content_type: "application/javascript"
  end

  class Bartaskclass
    attr :id,true
    attr :user_id,true
    attr :preprice,true
    attr :province,true
    attr :city,true
    attr :district,true
    attr :address,true
    attr :status,true
    attr :installtime,true
    attr :ordernumber,true
    attr :created_at,true
    attr :updated_at,true
    attr :contact,true
    attr :contactphone,true
    attr :contract,true
    attr :paytype,true
    attr :measurecount,true
    attr :transitcount,true
    attr :fingercount,true
    attr :bartaskdetailcount,true
    attr :openlockcount,true
    attr :isselect,true
    attr :artisancount,true
    attr :hasoffer,true
    attr :maskaddress,true
    attr :offerstatus,true
    attr :artisancount,true
    attr :artisan,true
    attr :price,true
    attr :servicetype,true
    attr :registrant,true
    attr :summary,true

  end

  def getbartask
    user = User.find_by_openid(params[:openid])
    bartasks = user.bartasks.where('status = 1')
    bartasks.each do |f|
      if f.installtime.to_s.length > 0 && Time.now - 1.days > f.installtime
        f.status = -2
        f.save
      end
    end
    bartasks = user.bartasks.order('id desc')
    bartaskarr = Array.new
    bartasks.each do |f|
      bartaskcla = Bartaskclass.new
      bartaskcla.id = f.id
      bartaskcla.user_id = f.user_id
      bartaskcla.preprice = f.preprice
      bartaskcla.province = f.province
      bartaskcla.city = f.city
      bartaskcla.district = f.district
      bartaskcla.address = f.address
      bartaskcla.status = f.status
      bartaskcla.installtime = f.installtime
      bartaskcla.ordernumber = f.ordernumber
      bartaskcla.created_at = f.created_at
      bartaskcla.updated_at = f.updated_at
      bartaskcla.paytype = f.paytype
      bartaskcla.measurecount = f.measures.count
      bartaskcla.transitcount = f.transits.count
      bartaskcla.fingercount = f.fingers.count
      bartaskcla.bartaskdetailcount = f.bartaskdetails.count
      bartaskcla.openlockcount = f.openlocks.count
      bartaskcla.artisancount = f.offers.count
      servicetype = ''
      if bartaskcla.measurecount > 0
        servicetype = servicetype + '测量'
      end
      if bartaskcla.transitcount > 0
        servicetype = servicetype + '运输'
      end
      if bartaskcla.bartaskdetailcount > 0
        servicetype = servicetype + '安装'
      end
      if bartaskcla.openlockcount > 0
        servicetype = servicetype + '维修 开锁'
      end
      if bartaskcla.fingercount > 0
        finger = f.fingers.first.fingermodeldef
        if finger
          servicetype = servicetype + finger.model
        end
      end
      bartaskcla.servicetype = servicetype

      bartaskarr.push bartaskcla
    end
    render json: params[:callback]+'({"bartasks":'+ bartaskarr.to_json + '})',content_type: "application/javascript"
  end

  def getartisanbartask
    user = Artisanuser.find_by_openid(params[:openid])
    bartasks = Bartask.where('status = 1')
    bartasks.each do |f|
      if f.installtime.to_s.length > 0 && Time.now - 1.days > f.installtime
        f.status = -2
        f.save
      end
    end
    bartasks = Bartask.order('id desc')
    bartaskarr = Array.new
    bartasks.each do |f|
      bartaskcla = Bartaskclass.new
      bartaskcla.id = f.id
      bartaskcla.user_id = f.user_id
      bartaskcla.preprice = f.preprice
      bartaskcla.province = f.province
      bartaskcla.city = f.city
      bartaskcla.district = f.district
      if f.address.to_s.length > 4
        bartaskcla.maskaddress = f.address.to_s[0,f.address.to_s.length - 4] + '****'
      else
        bartaskcla.maskaddress = '****'
      end
      bartaskcla.address = f.address
      bartaskcla.status = f.status
      bartaskcla.installtime = f.installtime
      bartaskcla.ordernumber = f.ordernumber
      bartaskcla.created_at = f.created_at
      bartaskcla.updated_at = f.updated_at
      bartaskcla.paytype = f.paytype
      bartaskcla.measurecount = f.measures.count
      bartaskcla.transitcount = f.transits.count
      bartaskcla.fingercount = f.fingers.count
      bartaskcla.bartaskdetailcount = f.bartaskdetails.count
      bartaskcla.openlockcount = f.openlocks.count
      bartaskcla.artisancount = f.offers.count
      bartaskcla.paytype = f.paytype
      offer = Offer.where('artisanuser_id = ? and bartask_id = ?',user.id,f.id)
      if offer.count > 0
        bartaskcla.hasoffer = 1
        bartaskcla.offerstatus = 1
      else
        bartaskcla.hasoffer = 0
        bartaskcla.offerstatus = 0
      end

      userpayorder = Userpayorder.where('bartask_id = ? and status = ? and artisanuser_id = ?',f.id,1,user.id)
      if userpayorder.count > 0
        bartaskcla.offerstatus = 2
      end
      userpayorder = Userpayorder.where('bartask_id = ? and status = ?',f.id,1)
      if userpayorder.count > 0
        bartaskcla.offerstatus = 3
      end
      bartaskcla.servicetype = ''
      if bartaskcla.measurecount > 0
        bartaskcla.servicetype = '测量'
      end
      if bartaskcla.transitcount > 0
        bartaskcla.servicetype = bartaskcla.servicetype + '运输'
      end
      if bartaskcla.fingercount > 0
        #bartaskcla.servicetype = bartaskcla.servicetype + '指纹锁安装'
        finger = f.fingers.first.fingermodeldef
        if finger
          bartaskcla.servicetype = bartaskcla.servicetype + finger.model
        end
      end
      if bartaskcla.bartaskdetailcount > 0
        bartaskcla.servicetype = bartaskcla.servicetype + '安装'
      end
      if bartaskcla.openlockcount > 0
        bartaskcla.servicetype = bartaskcla.servicetype + '维修 开锁'
      end

      bartaskarr.push bartaskcla
    end
    render json: params[:callback]+'({"bartasks":'+ bartaskarr.to_json + '})',content_type: "application/javascript"
  end

  def getareaartisanbartask
    user = Artisanuser.find_by_openid(params[:openid])
    bartasks = Bartask.order('id desc').where('province like ? and city like ? and district like ?',"%#{params[:province]}%","%#{params[:city]}%","%#{params[:district]}%")
    bartaskarr = Array.new
    bartasks.each do |f|
      bartaskcla = Bartaskclass.new
      bartaskcla.id = f.id
      bartaskcla.user_id = f.user_id
      bartaskcla.preprice = f.preprice
      bartaskcla.province = f.province
      bartaskcla.city = f.city
      bartaskcla.district = f.district
      if f.address.to_s.length > 4
        bartaskcla.maskaddress = f.address.to_s[0,f.address.to_s.length - 4] + '****'
      else
        bartaskcla.maskaddress = '****'
      end
      bartaskcla.address = f.address
      bartaskcla.status = f.status
      bartaskcla.installtime = f.installtime
      bartaskcla.ordernumber = f.ordernumber
      bartaskcla.created_at = f.created_at
      bartaskcla.updated_at = f.updated_at
      bartaskcla.paytype = f.paytype
      bartaskcla.measurecount = f.measures.count
      bartaskcla.transitcount = f.transits.count
      bartaskcla.fingercount = f.fingers.count
      bartaskcla.bartaskdetailcount = f.bartaskdetails.count
      bartaskcla.openlockcount = f.openlocks.count
      bartaskcla.artisancount = f.offers.count
      bartaskcla.paytype = f.paytype
      offer = Offer.where('artisanuser_id = ? and bartask_id = ?',user.id,f.id)
      if offer.count > 0
        bartaskcla.hasoffer = 1
        bartaskcla.offerstatus = 1
      else
        bartaskcla.hasoffer = 0
        bartaskcla.offerstatus = 0
      end

      userpayorder = Userpayorder.where('bartask_id = ? and status = ? and artisanuser_id = ?',f.id,1,user.id)
      if userpayorder.count > 0
        bartaskcla.offerstatus = 2
      end
      userpayorder = Userpayorder.where('bartask_id = ? and status = ?',f.id,1)
      if userpayorder.count > 0
        bartaskcla.offerstatus = 3
      end
      bartaskcla.servicetype = ''
      if bartaskcla.measurecount > 0
        bartaskcla.servicetype = '测量'
      end
      if bartaskcla.transitcount > 0
        bartaskcla.servicetype = bartaskcla.servicetype + '运输'
      end
      if bartaskcla.fingercount > 0
        finger = f.fingers.first.fingermodeldef
        if finger
          bartaskcla.servicetype = bartaskcla.servicetype + finger.model
        end
      end
      if bartaskcla.bartaskdetailcount > 0
        bartaskcla.servicetype = bartaskcla.servicetype + '安装'
      end
      if bartaskcla.openlockcount > 0
        bartaskcla.servicetype = bartaskcla.servicetype + '维修 开锁'
      end

      bartaskarr.push bartaskcla
    end
    render json: params[:callback]+'({"bartasks":'+ bartaskarr.to_json + '})',content_type: "application/javascript"
  end

  class Bartaskdetailclass
    attr :id,true
    attr :bartask_id,true
    attr :product,true
    attr :lock,true
    attr :brand,true
    attr :projectdef,true
  end

  class Barbaseclass
    attr :id,true
    attr :bartaskdetail_id,true
    attr :name,true
    attr :summary,true
    attr :isselect,true
  end

  class Fingerclass
    attr :id,true
    attr :model,true
    attr :summary,true
  end

  def getbartaskdetail
    bartask = Bartask.find(params[:id])
    bartaskcla = Bartaskclass.new
    bartaskcla.id = bartask.id
    bartaskcla.user_id = bartask.user_id
    bartaskcla.preprice = bartask.preprice
    bartaskcla.province = bartask.province
    bartaskcla.city = bartask.city
    bartaskcla.district = bartask.district
    bartaskcla.address = bartask.address
    bartaskcla.status = bartask.status
    bartaskcla.installtime = bartask.installtime
    bartaskcla.ordernumber = bartask.ordernumber
    bartaskcla.created_at = bartask.created_at
    bartaskcla.updated_at = bartask.updated_at
    bartaskcla.contact = bartask.contact
    bartaskcla.contactphone = bartask.contactphone
    bartaskcla.paytype = bartask.paytype
    bartaskcla.registrant = ''
    if bartask.user && bartask.user.login.to_s != ''
      bartaskcla.registrant = bartask.user.login
    end
    bartaskcla.summary = bartask.summary


    bartaskdetails = bartask.bartaskdetails

    bartaskdetailarr = Array.new
    barbasedefarr = Array.new
    barincrementdefarr = Array.new
    uuid = UUID.new
    bartaskdetails.each do |f|
      bartaskdetailcla = Bartaskdetailclass.new
      bartaskdetailcla.id = f.id
      bartaskdetailcla.bartask_id = f.bartask_id
      bartaskdetailcla.product = Product.find(f.product_id).product
      bartaskdetailcla.lock = Lock.find(f.lock_id).lock
      bartaskdetailcla.projectdef = ''
      if f.projectdef
        bartaskdetailcla.projectdef = f.projectdef.project
      end
      bartaskdetailcla.brand = f.brand
      bartaskdetailarr.push bartaskdetailcla
      barbasedefids = f.barbasedefs.ids
      barbasedefs = Barbasedef.all
      barbasedefs.each do |barbase|
        barbasecla = Barbaseclass.new
        barbasecla.id = uuid.generate.tr('-','')
        barbasecla.bartaskdetail_id = f.id
        barbasecla.name = barbase.name
        barbasecla.summary = barbase.summary
        if barbasedefids.include? barbase.id
          barbasecla.isselect = 1
        else
          barbasecla.isselect = 0
        end
        barbasedefarr.push barbasecla
      end
      barincrementdefids = f.barincrementdefs.ids
      barincrementdefs = Barincrementdef.all
      barincrementdefs.each do |barincrement|
        barincrementcla = Barbaseclass.new
        barincrementcla.id = uuid.generate.tr('-','')
        barincrementcla.bartaskdetail_id = f.id
        barincrementcla.name = barincrement.name
        barincrementcla.summary = barincrement.summary
        if barincrementdefids.include? barincrement.id
          barincrementcla.isselect = 1
        else
          barincrementcla.isselect = 0
        end
        barincrementdefarr.push barincrementcla
      end
    end
    measures = bartask.measures
    transits = bartask.transits
    fingers = bartask.fingers
    fingerarr = Array.new
    fingers.each do |f|
      fingercla = Fingerclass.new
      fingercla.id = f.id
      fingercla.model = f.fingermodeldef.model
      fingercla.summary = f.summary
      fingerarr.push fingercla
    end
    openlocks = bartask.openlocks

    render json: params[:callback]+'({"bartask":' + bartaskcla.to_json + ',"bartaskdetails":'+ bartaskdetailarr.to_json + ',"measures":' + measures.to_json + ',"transits":'+ transits.to_json + ',"openlocks":' + openlocks.to_json + ',"fingers":' + fingerarr.to_json + ',"barbasedefs":' +barbasedefarr.to_json + ',"barincrementdefs":' +barincrementdefarr.to_json + '})',content_type: "application/javascript"
  end

  def sendvcodesms
    randnum = randnumber
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuser.valicode = randnum
    artisanuser.valitime = Time.now
    artisanuser.save
    sendvcode(params[:phone],randnum)
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def sendwithdrawvcodesms
    randnum = randnumber
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuser.valicode = randnum
    artisanuser.valitime = Time.now
    artisanuser.save
    sendvcode(artisanuser.login,randnum)
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def bindartisan
    status = 0
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    if artisanuser.valicode == params[:vcode] && artisanuser.valitime + 15.minutes > Time.now
      status = 1
      artisanuser.login = params[:phone]
      artisanuser.username = params[:name]
      artisanuser.save
      coupons = Coupon.where("coupontype = 3 and user_id is null and artisanuser_id is null")
      parent = artisanuser.user
      if parent
        coupons.each do |f|
          if f.expirytype == 1 && f.assignexpiry > Time.now
            f.artisanuser_id = artisanuser.id
            f.user_id = parent.id
            f.model = 2
            f.save
            break
          elsif f.expirytype == 2
            f.artisanuser_id = artisanuser.id
            f.user_id = parent.id
            f.assignexpiry = Time.now + f.fixedexpiry.days
            f.model = 2
            f.save
            break
          end
        end
      end
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def idfont
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuser.idfront = params[:idfront]
    artisanuser.save
    render json:'{"status":"200"}'
  end

  def idback
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuser.idback = params[:idback]
    artisanuser.save
    render json:'{"status":"200"}'
  end

  def getartisaninfo
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanusercla = Artisanuserclass.new
    artisanusercla.id = artisanuser.id
    artisanusercla.username = artisanuser.username
    artisanusercla.headurl = artisanuser.headurl
    artisanusercla.province = artisanuser.province
    artisanusercla.city = artisanuser.city
    artisanusercla.score = Userpayorder.where('artisanuser_id = ? and score is not null',artisanuser.id).average('score')
    artisanusercla.ordercount = Userpayorder.where('artisanuser_id = ? and status = 1',artisanuser.id).count

    render json: params[:callback]+'({"artisanuser":'+ artisanusercla.to_json + '})',content_type: "application/javascript"
  end

  class Eulaclass
    attr :title,true
    attr :eula,true
  end

  def geteula
    eula = Eula.first
    eulacla = Eulaclass.new
    eulacla.title = eula.tile
    eulacla.eula = eula.eula.html_safe
    render json: params[:callback]+'({"eula":'+ eulacla.to_json + '})',content_type: "application/javascript"
  end

  class Artisanuserservicecapclass
    attr :id,true
    attr :servicecap_id,true
    attr :servicecap,true
    attr :flag,true
  end

  def getartisanservicecap
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuserservicecalarr = Array.new
    servicecaps = Servicecap.all
    step = 0
    servicecaps.each do |servicecap|
      artisanuserservicecapcla = Artisanuserservicecapclass.new
      step += 1
      artisanuserservicecapcla.id = step
      artisanuserservicecapcla.servicecap_id = servicecap.id
      artisanuserservicecapcla.servicecap = servicecap.servicecap
      artisanuserservicecap = artisanuser.servicecaps.where('servicecap_id = ?',servicecap.id)
      if artisanuserservicecap.count > 0
        artisanuserservicecapcla.flag = 1
      else
        artisanuserservicecapcla.flag = 0
      end
      artisanuserservicecalarr.push artisanuserservicecapcla
    end
    render json: params[:callback]+'({"servicecaps":'+ artisanuserservicecalarr.to_json + '})',content_type: "application/javascript"
  end

  def setservicecap
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuser.servicecaps.delete_all
    JSON.parse(params[:servicecapdata])['rows'].each do |row|
      if row['flag'].to_s == '1'
        servicecap = Servicecap.find(row['servicecap_id'])
        artisanuser.servicecaps << servicecap
      end
    end
    render json:'{"status":"200"}'
  end

  def setoffer
    bartask = Bartask.find(params[:orderid])
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    Offer.create(artisanuser_id:artisanuser.id,bartask_id:bartask.id,price:params[:price],summary:params[:summary],isselect:0)
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def getoffer
    bartask = Bartask.find(params[:orderid])
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    offer = Offer.where("artisanuser_id = ? and bartask_id = ?",artisanuser.id,bartask.id).first
    render json: params[:callback]+'({"offer":'+ offer.to_json + '})',content_type: "application/javascript"
  end

  def getofferartisan
    bartask = Bartask.find(params[:orderid])
    offer = Offer.where('bartask_id =?',bartask.id)
    artisanids = Array.new
    artisanids.push 0
    offer.each do |f|
      artisanids.push f.artisanuser_id
    end
    artisans = Artisanuser.where('id in(?)',artisanids)
    artisanuserarr = Array.new
    artisans.each do |f|
      artisanusercla = Artisanuserclass.new
      artisanusercla.id = f.id
      artisanusercla.login = f.login
      artisanusercla.username = f.username
      artisanusercla.headurl = f.headurl
      collection = f.users
      if collection.count > 0
        artisanusercla.iscollection = 1
      else
        artisanusercla.iscollection = 0
      end

      artisanusercla.score = Userpayorder.where('artisanuser_id = ? and score is not null',f.id).average('score')
      artisanusercla.ordercount = Userpayorder.where('artisanuser_id = ? and status = 1',f.id).count

      artisanuserarr.push artisanusercla
    end

    render json: params[:callback]+'({"artisans":'+ artisanuserarr.to_json + ',"offers":' + offer.to_json + '})',content_type: "application/javascript"
  end

  def getprocesstask
    user = User.find_by_openid(params[:openid])
    bartasks = user.bartasks.where('status in(?)',[2,3,4,5,-1])
    bartaskarr = Array.new
    bartasks.each do |bartask|
      bartaskcla = Bartaskclass.new
      bartaskcla.id = bartask.id
      bartaskcla.ordernumber = bartask.ordernumber
      bartaskcla.province = bartask.province
      bartaskcla.city = bartask.city
      bartaskcla.district = bartask.district
      bartaskcla.address = bartask.address
      bartaskcla.installtime = bartask.installtime
      userpayorder = Userpayorder.where('bartask_id = ? and status = ?',bartask.id,1).first
      if userpayorder
        bartaskcla.artisan = Artisanuser.find(userpayorder.artisanuser_id).username
        bartaskcla.price = userpayorder.price
      else
        bartaskcla.price = 0
      end

      bartaskcla.measurecount = bartask.measures.count
      bartaskcla.transitcount = bartask.transits.count
      bartaskcla.fingercount = bartask.fingers.count
      bartaskcla.openlockcount = bartask.openlocks.count
      bartaskcla.bartaskdetailcount = bartask.bartaskdetails.count
      servicetype = ''
      if bartaskcla.measurecount > 0
        servicetype = servicetype + '测量'
      end
      if bartaskcla.transitcount > 0
        servicetype = servicetype + '运输'
      end
      if bartaskcla.bartaskdetailcount > 0
        servicetype = servicetype + '安装'
      end
      if bartaskcla.openlockcount > 0
        servicetype = servicetype + '维修 开锁'
      end
      if bartaskcla.fingercount > 0
        finger = bartask.fingers.first.fingermodeldef
        if finger
          servicetype = servicetype + finger.model
        end
      end
      bartaskcla.servicetype = servicetype
      bartaskcla.paytype = bartask.paytype
      bartaskcla.status = bartask.status
      bartaskarr.push bartaskcla

    end
    render json: params[:callback]+'({"processtask":'+ bartaskarr.to_json + '})',content_type: "application/javascript"
  end

  class Bartaskproimageclass
    attr :id,true
    attr :bartaskproimage,true
  end

  def getbartaskpro
    refreshbartaskpro(params[:orderid],params[:openid])
  end

  def beginservice
    bartask = Bartask.find(params[:orderid])
    bartask.status = 3
    bartask.save
    bartaskpro = bartask.bartaskpros.first
    bartaskpro.begintime = Time.now
    bartaskpro.save
    refreshbartaskpro(params[:orderid],params[:openid])
  end

  def endservice
    bartask = Bartask.find(params[:orderid])
    bartask.status = 4
    bartask.save
    bartaskpro = bartask.bartaskpros.first
    bartaskpro.endtime = Time.now
    bartaskpro.summary = params[:summary]
    bartaskpro.receivable = params[:receivable]
    bartaskpro.save
    refreshbartaskpro(params[:orderid],params[:openid])
  end

  def setbartaskimage
    bartaskpro = Bartaskpro.find(params[:bartaskproid])
    bartaskproimages = bartaskpro.bartaskproimages
    bartaskproimages.create(bartaskproimage:params[:bartaskproimage])
    refreshbartaskpro(params[:orderid],params[:openid])
  end

  class Bartaskproclass
    attr :id,true
    attr :artisanuserid,true
    attr :artisanuser,true
    attr :begintime,true
    attr :endtime,true
    attr :summary,true
    attr :bartaskproimages,true
    attr :amount,true
    attr :receivable,true
    attr :needreceivable,true
  end

  def getuserbartaskpro
    bartask = Bartask.find(params[:orderid])
    bartaskpro = bartask.bartaskpros.first
    bartaskprocla = Bartaskproclass.new
    bartaskprocla.id = bartaskpro.id
    artisanuser = Artisanuser.find(bartaskpro.artisanuser_id)
    bartaskprocla.artisanuserid = artisanuser.id
    bartaskprocla.artisanuser = artisanuser.username
    bartaskprocla.begintime = bartaskpro.begintime
    bartaskprocla.endtime = bartaskpro.endtime
    bartaskprocla.summary = bartaskpro.summary
    bartaskproimage = bartaskpro.bartaskproimages
    bartaskprocla.amount = Userpayorder.find_by(bartask_id:bartask.id).price
    bartaskprocla.receivable = bartaskpro.receivable
    bartaskprocla.needreceivable = bartaskpro.needreceivable
    bartaskproimagearr = Array.new
    bartaskproimage.each do |f|
      bartaskproimagecla = Bartaskproimageclass.new
      bartaskproimagecla.id = f.id
      bartaskproimagecla.bartaskproimage = f.bartaskproimage.url
      bartaskproimagearr.push bartaskproimagecla
    end
    bartaskprocla.bartaskproimages = bartaskproimagearr
    render json: params[:callback]+'({"bartaskpro":'+ bartaskprocla.to_json + '})',content_type: "application/javascript"
  end

  def acceptance
    bartask = Bartask.find(params[:orderid])
    bartask.status = 5
    bartask.save
    userpayorder = Userpayorder.where('bartask_id = ? and status = 1',params[:orderid]).first
    userpayorder.skillscore = params[:skill]
    userpayorder.attitudescore = params[:attitude]
    userpayorder.conceptscore = params[:concept]
    userpayorder.score = (userpayorder.skillscore.to_f + userpayorder.attitudescore.to_f + userpayorder.conceptscore.to_f) / 3
    userpayorder.summary = params[:summary]
    userpayorder.save
    artisanuser = Artisanuser.find(userpayorder.artisanuser_id)
    price = userpayorder.price
    coupon = Coupon.find_by_ordernumber(bartask.ordernumber)
    if coupon
      price += coupon.facevalue
    end
    servicecom = Servicecom.first
    serviceamount = servicecom.base + servicecom.percent / 100.0 * price
    if serviceamount > 0
      Profit.create(ordernumber:bartask.ordernumber,amount:serviceamount,summary:'订单提成')
    end
    distcom = Distcom.first
    distamount = distcom.distcom / 100.0 * price
    if artisanuser.parent && distamount > 0
      artisanuser.parent.artisanextacts.create(ordernumber:bartask.ordernumber,amount:distamount,children:artisanuser.id)
      Profit.create(amount:-distamount,summary:'技工推荐分销提成')
    elsif artisanuser.user && distamount > 0
      artisanuser.user.userextracts.create(ordernumber:bartask.ordernumber,amount:distamount,children:artisanuser.id)
      Profit.create(amount:-distamount,summary:'用户推荐推荐分销提成')
    end
    artisanuser.incomes.create(amount:-serviceamount,bartaskorder:bartask.ordernumber,status:1,summary:'平台服务费')
    artisanuser.incomes.create(amount:price,bartaskorder:bartask.ordernumber,status:1,summary:'收入')
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def avaamount
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    income = artisanuser.incomes.sum('amount')
    withdraw = artisanuser.widthdraws.sum('amount')
    ava = income - withdraw + artisanuser.artisanextracts.sum('amount')
    render json: params[:callback]+'({"avaamount":'+ ava.to_s + '})',content_type: "application/javascript"
  end

  def checkartisanuserpwd
    status = 0
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    withdraw = artisanuser.withdrawpwds
    if withdraw.count > 0
      status = 1
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def checkartisanuservcode
    status = 0
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    if params[:vcode] == artisanuser.valicode && artisanuser.valitime + 15.minutes > Time.now
      status = 1
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def setwithdrawpwd
    status = 1
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    withdrawpwd = artisanuser. withdrawpwds
    if withdrawpwd.count > 0
      withdrawpwd.first.password = params[:password]
      withdrawpwd.first.password_confirmation = params[:password]
      withdrawpwd.first.save
    else
      withdrawpwd.create(password:params[:password], password_confirmation:params[:password])
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def checkwithdrawpwd
    status = 0 #0未设置密码 1密码错误 2 提现错误 3提现正常
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    withdrawpwds = artisanuser.withdrawpwds
    if withdrawpwds.count > 0
      withdrawpwd = withdrawpwds.first.try(:authenticate, params[:password])
      if withdrawpwd
        nonce=SecureRandom.uuid.tr('-', '')
        tradeno = Time.now.strftime('%Y%m%d%H%M%S') + artisanuser.id.to_s
        payment_params={
            nonce_str:nonce,
            partner_trade_no:tradeno,
            openid:params[:openid],
            check_name:'NO_CHECK',
            amount:(params[:amount].to_f * 100).to_i,
            desc:'刘叔叔装门平台提现',
            spbill_create_ip:'127.0.0.1'
        }
        @result = WxPay::Service.invoke_transfer(payment_params)
        #debugger
        if @result["result_code"]=="SUCCESS"
          status = 3
          withdraws = artisanuser.widthdraws
          withdraws.create(amount:params[:amount].to_f,withdrawto:0,summary:'提现成功',tradeno:tradeno)
          #render json: params[:callback]+'({"status":"1","withdraw":'+withdraws.to_json+'})',content_type: "application/javascript"
        else
          status = 2
          #render json: params[:callback]+'({"status":"0"})',content_type: "application/javascript"
        end
      else
        status = 1
      end
    end

    #debugger
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def userunpaidcancel
    status = 0
    bartask = Bartask.find(params[:orderid])
    bartask.status = -1
    bartask.save
    Cancelorder.create(user_id:bartask.user_id, ordernumber:bartask.ordernumber, cancelparty:'用户', amount:'0', reason:params[:reason],opinions:'', status:1)
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def userpaidcancel
    status = 0
    bartask = Bartask.find(params[:orderid])
    bartask.status = -1
    bartask.save
    Cancelorder.create(user_id:bartask.user_id, ordernumber:bartask.ordernumber, cancelparty:'用户', amount:params[:amount], reason:params[:reason],opinions:'', status:0)
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def getusercancelreason
    usercancelreasons = Usercancelreason.all
    render json: params[:callback]+'({"usercancelreason":'+ usercancelreasons.to_json + '})',content_type: "application/javascript"
  end

  def getfingermodeldefs
    fingermodeldefs = Fingermodeldef.all
    render json: params[:callback]+'({"fingermodeldefs":'+ fingermodeldefs.to_json + '})',content_type: "application/javascript"
  end

  def getbankcode
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    bankcode = Bankcode.all
    render json: params[:callback]+'({"bankcode":'+ bankcode.to_json + ',"artisanuser":' + artisanuser.to_json + '})',content_type: "application/javascript"
  end

  def bindbankcard
    status = 1
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    bankcards = artisanuser.bankcards
    bankcode = Bankcode.find(params[:bankcodeid])
    bankcards.create(bankcode_id:bankcode.id, cardnumber:params[:cardnumber], name:params[:name])
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  class Bankcardclass
    attr :id,true
    attr :cardnumber,true
    attr :name,true
    attr :bankcode,true
  end

  def getbankcards
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    bankcards = artisanuser.bankcards
    bankcardarr = Array.new
    bankcards.each do |f|
      bankcardcla = Bankcardclass.new
      bankcardcla.id = f.id
      bankcardcla.cardnumber = f.cardnumber[0,4] +'****' + f.cardnumber[-4,4]
      bankcardcla.name = f.name
      bankcardcla.bankcode = Bankcode.find(f.bankcode_id).bank
      bankcardarr.push bankcardcla
    end
    render json: params[:callback]+'({"bankcards":'+ bankcardarr.to_json + '})',content_type: "application/javascript"
  end

  def deletebankcard
    status = 1
    bankcard = Bankcard.find(params[:bankcardid])
    bankcard.destroy
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def getwithdrawrecord
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    withdraws = artisanuser.widthdraws.order('id desc')
    withdraws.each do |f|
      if f.withdrawto == 1
        querybank(f.tradeno)
      end
    end
    render json: params[:callback]+'({"withdraws":'+ withdraws.to_json + '})',content_type: "application/javascript"
  end

  def checkcollection #检查用户是否关注过技工
    status = 0 #未关注
    artisanuser = Artisanuser.find_by(id:params[:artisanuserid])
    user = User.find_by_openid(params[:openid])
    artisanusers = user.artisanusers.where('artisanuser_id = ?',artisanuser.id)
    if artisanusers.count > 0
      status = 1 #  已关注过
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def collectionartisan #收藏技工
    status = 1
    artisanuser = Artisanuser.find_by(id:params[:artisanuserid])
    user = User.find_by_openid(params[:openid])
    artisanusers = user.artisanusers.where('artisanuser_id = ?',artisanuser.id)
    if artisanusers.count > 0
      user.artisanusers.destroy(artisanuser)
    else
      user.artisanusers << artisanuser
    end

    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def getmycollectionartisanlist
    user = User.find_by_openid(params[:openid])
    artisanusers = user.artisanusers
    render json: params[:callback]+'({"artisanusers":'+ artisanusers.to_json + '})',content_type: "application/javascript"
  end

  class Artisanuserclass
    attr :id,true
    attr :username,true
    attr :headurl,true
    attr :login,true
    attr :servicenumber,true
    attr :score,true
    attr :skillscore,true
    attr :conceptscore,true
    attr :attitudescore,true
    attr :iscollection,true
    attr :ordercount,true
    attr :province,true
    attr :city,true
    attr :district,true
  end

  def getartisanuser
    artisanuser = Artisanuser.find_by(id:params[:artisanuserid])
    artisanusercla = Artisanuserclass.new
    artisanusercla.id = artisanuser.id
    artisanusercla.username = artisanuser.username
    artisanusercla.login = artisanuser.login
    artisanusercla.headurl = artisanuser.headurl
    userpayorders = Userpayorder.where('artisanuser_id = ? and score > ?',artisanuser.id,0)
    artisanusercla.servicenumber = userpayorders.count
    artisanusercla.score = userpayorders.average('score')
    artisanusercla.skillscore = userpayorders.average('skillscore')
    artisanusercla.conceptscore = userpayorders.average('conceptscore')
    artisanusercla.attitudescore = userpayorders.average('attitudescore')
    render json: params[:callback]+'({"artisanuser":' + artisanusercla.to_json + '})',content_type: "application/javascript"
  end

  def createqrcode
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanqrcodetran(artisanuser.id)
    render json: params[:callback]+'({"qrcodeurl":"' + artisanuser.artisanuserqrcodeimg.to_s + '"})',content_type: "application/javascript"
  end

  def createuserqrcode
    user = User.find_by_openid(params[:openid])
    userqrcodetran(user.id)
    render json: params[:callback]+'({"qrcodeurl":"' + user.userqrcodeimg.to_s + '"})',content_type: "application/javascript"
  end

  def sign
    $client ||= WeixinAuthorize::Client.new("wxb3d1ca1df413ce9d", "c4a1d6d2a1b5af73a6666e1308e61595")
    sign_package = $client.get_jssign_package(params[:url].split('#')[0])
    render json: params[:callback]+'('+ sign_package.to_json + ')',content_type: "application/javascript"
  end



  def senduservcodesms
    randnum = randnumber
    user = User.find_by_openid(params[:openid])
    user.valicode = randnum
    user.valitime = Time.now
    user.save
    sendvcode(params[:phone],randnum)
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def binduser
    status = 0
    user = User.find_by_openid(params[:openid])
    if user.valicode == params[:vcode] && user.valitime + 15.minutes > Time.now
      status = 1
      user.login = params[:phone]
      user.province = params[:province]
      user.city = params[:city]
      user.district = params[:district]
      user.save

      ##########注册领取##############
      coupons = Coupon.where("coupontype = 1 and city like ?","%#{user.city}%")
      coupons.each do |f|
        if f.expirytype == 1 && f.assignexpiry > Time.now
          f.user_id = user.id
          f.save
          break
        elsif f.expirytype == 2
          f.user_id = user.id
          f.assignexpiry = Time.now + f.fixedexpiry.days
          f.save
          break
        end
      end
      #############注册领取END ############

    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def getuserinfo
    user = User.find_by_openid(params[:openid])
    render json: params[:callback]+'({"user":'+ user.to_json + '})',content_type: "application/javascript"
  end

  class Couponclass
    attr :id,true
    attr :couponbat_id,true
    attr :user_id,true
    attr :artisanuser_id,true
    attr :model,true
    attr :facevalue,true
    attr :condition,true
    attr :expirytype,true
    attr :assignexpiry,true
    attr :fixedexpiry,true
    attr :ordernumber,true
    attr :alreadyused,true
    attr :name,true
    attr :couponnumber,true
    attr :summary,true
    attr :status,true
    attr :coupontype,true
    attr :city,true
    attr :artisan,true
  end

  def getcoupon
    user = User.find_by_openid(params[:openid])
    coupons = Coupon.where('user_id = ? and alreadyused = 0 and assignexpiry > ?',user.id,Time.now)
    couponarr = Array.new
    coupons.each do |f|
      couponcla = Couponclass.new
      couponcla.id = f.id
      couponcla.couponbat_id = f.couponbat_id
      couponcla.user_id = f.user_id
      couponcla.artisanuser_id = f.artisanuser_id
      couponcla.model = f.model
      couponcla.facevalue = f.facevalue
      couponcla.condition = f.condition
      couponcla.expirytype = f.expirytype
      couponcla.assignexpiry = f.assignexpiry
      couponcla.fixedexpiry = f.fixedexpiry
      couponcla.ordernumber = f.ordernumber
      couponcla.alreadyused = f.alreadyused
      couponcla.name = f.name
      couponcla.couponnumber = f.couponnumber
      couponcla.summary = f.summary
      couponcla.status = f.status
      couponcla.coupontype = f.coupontype
      couponcla.city = f.city
      if f.artisanuser_id.to_s != ''
        couponcla.artisan = Artisanuser.find(f.artisanuser_id).username
      else
        couponcla.artisan = ''
      end
      couponarr.push couponcla
    end
    render json: params[:callback]+'({"coupons":'+ couponarr.to_json + '})',content_type: "application/javascript"
  end

  class Rankingclass
    attr :country,true
    attr :province,true
    attr :city,true
    attr :district,true
    attr :countrylist,true
    attr :provincelist,true
    attr :citylist,true
    attr :districtlist,true
  end

  class Rankingclass
    attr :id,true
    attr :username,true
    attr :headurl,true
    attr :aver,true
    attr :city,true
  end

  def getranking
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    #artisanuser = Artisanuser.find(1)
    countryarr = Array.new
    artisanusers = Artisanuser.all
    artisanusers.each do |f|
      country = Rankingclass.new
      score = Userpayorder.where('artisanuser_id = ? and score is not null and status = 1',f.id).average('score').to_f
      amount = Userpayorder.where('artisanuser_id = ? and score is not null and status = 1',f.id).sum('price').to_f
      aver = score * amount
      country.id = f.id
      if f.username.to_s.length > 0
        country.username = f.username[0].ljust(f.username.length,'*')
      end
      country.headurl = f.headurl
      country.city = f.city
      country.aver = aver
      countryarr.push country
    end
    countryarr.sort_by!{|k|k.aver}
    countryarr.reverse!
    mycountry = 0
    countryarr.each do |f|
      mycountry += 1
      if f.id == artisanuser.id
        break
      end
    end

    render json: params[:callback]+'({"country":' + countryarr[0..4].to_json + ',"mycountry":' + mycountry.to_s + '})',content_type: "application/javascript"
  end

  def set_artisan_area_server
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    artisanuser.province = params[:province]
    artisanuser.city = params[:city]
    artisanuser.save
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def get_artisan_incomes
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    incomes = artisanuser.incomes.order('id desc')
    render json: params[:callback]+'({"incomes":'+ incomes.to_json + '})',content_type: "application/javascript"
  end

  class Extractclass
    attr :id,true
    attr :headurl,true
    attr :amount,true
    attr :name,true
  end

  def get_artisan_extract
    artisanuser = Artisanuser.find_by_openid(params[:openid])
    extracts = artisanuser.extracts
    artisanuseridarr = Array.new
    extracts.each do |f|
      artisanuseridarr.push Userpayorder.find_by_ordernumber(f.ordernumber).artisanuser_id
    end
    artisanuseridarr.uniq!
  end

  def get_user_extract
    user = User.find_by_openid(params[:openid])
    extracts = user.userextracts
    useridarr = Array.new
    extracts.each do |f|
      useridarr.push f.children
    end
    useridarr.uniq!
    extractarr = Array.new
    useridarr.each do |f|
      extractcla = Extractclass.new
      temuser = Artisanuser.find(f)
      extractcla.id = temuser.id
      extractcla.headurl = temuser.headurl
      extractcla.name = ''
      if temuser.to_s != ''
        extractcla.name = temuser.username[0].ljust(temuser.username.length,'*')
      end
      extractcla.amount = Userextract.where('children = ?',f).sum('amount')

      extractarr.push extractcla
    end
    render json: params[:callback]+'({"extracts":'+ extractarr.to_json + '})',content_type: "application/javascript"
  end

  private

  def refreshbartaskpro(orderid,openid)
    bartask = Bartask.find(orderid)
    artisanuser = Artisanuser.find_by_openid(openid)
    bartaskpros = bartask.bartaskpros
    needreceivable = 0
    if bartask.preprice > 0
      needreceivable = 1
    end
    if bartaskpros.count == 0
      bartask.bartaskpros.create(artisanuser_id:artisanuser.id,needreceivable:needreceivable)
      bartaskpros = bartask.bartaskpros
    end
    bartaskproimages = bartaskpros.first.bartaskproimages
    bartaskproimagearr = Array.new
    bartaskproimages.each do |f|
      bartaskproimagecla = Bartaskproimageclass.new
      bartaskproimagecla.bartaskproimage = f.bartaskproimage.url
      bartaskproimagearr.push bartaskproimagecla
    end
    render json: params[:callback]+'({"processtask":'+ bartaskpros.first.to_json + ',"bartaskproimages":' + bartaskproimagearr.to_json + '})',content_type: "application/javascript"
  end

  def randnumber
    vcode=''
    6.times do
      vcode+=rand(10).to_s
    end
    return vcode
  end

end
