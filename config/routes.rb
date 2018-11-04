Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :barbasedefs
  resources :barincrementdefs
  resources :products
  resources :locks
  resources :apis do
    collection do
      get 'getproducts'
      get 'getbarbases'
      get 'getbarincrements'
      post 'setbartask'
      get 'setwxuserinfo'
      get 'getwxuserinfo'
      get 'getlocks'
      get 'getbartask'
      get 'getbartaskdetail'
      get 'setwxartisaninfo'
      get 'sendvcodesms'
      post 'idfont'
      post 'idback'
      get 'bindartisan'
      get 'getartisaninfo'
      get 'geteula'
      get 'getartisanservicecap'
      post 'setservicecap'
      get 'getartisanbartask'
      get 'setoffer'
      get 'getoffer'
      get 'getofferartisan'
      get 'getprocesstask'
      get 'getbartaskpro'
      get 'beginservice'
      get 'endservice'
      post 'setbartaskimage'
      get 'getuserbartaskpro'
      get 'acceptance'
      get 'avaamount'
      get 'checkartisanuserpwd'
      get 'sendwithdrawvcodesms'
      get 'checkartisanuservcode'
      get 'setwithdrawpwd'
      get 'checkwithdrawpwd'
      get 'getareaartisanbartask'
      get 'userunpaidcancel'
      get 'userpaidcancel'
      get 'getusercancelreason'
      get 'getfingermodeldefs'
      get 'getbankcode'
      get 'bindbankcard'
      get 'getbankcards'
      get 'deletebankcard'
      get 'getwithdrawrecord'
      get 'checkcollection'
      get 'collectionartisan'
      get 'getmycollectionartisanlist'
      get 'getartisanuser'
      get 'createqrcode'
      get 'createuserqrcode'
      get 'sign'
      get 'senduservcodesms'
      get 'binduser'
      get 'getuserinfo'
      get 'getcoupon'
      get 'getranking'
      get 'set_artisan_area_server'
      get 'getprojectdefs'
      get 'get_artisan_incomes'
      get 'get_user_extract'
    end
  end
  resources :getopenids do
    collection do
      get 'getopenid'
    end
  end
  resources :getartisanuseropenids do
    collection do
      get 'getopenid'
    end
  end
  resources :eulas
  resources :servicecaps
  resources :wxpayments do
    collection do
      get 'pay'
      post 'notify'
    end
  end
  resources :ordercounts do
    collection do
      get 'getprovince'
      get 'getcity'
      get 'getdistrict'
    end
  end
  resources :mytests
  resources :paybanks do
    collection do
      get 'querybank'
      get 'payuser'
    end
  end
  resources :bankcodes
  resources :events do
    collection do
      get 'getqrcode'
      post 'getevent'
    end
  end
  resources :couponbats do
    collection do
      get 'getprogress'
    end
    resources :allotusercoupons
  end
  resources :users
  resources :distcoms
  resources :servicecoms
  resources :projectdefs
  resources :cancelorders
  resources :logins
  resources :admins do
    collection do
      get 'checkuser'
    end
  end
  resources :payusers do
    collection do
      get 'pay'
    end
  end



end
