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

end
