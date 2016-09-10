Rails.application.routes.draw do
  # 分三層
  # 第一層：public

  resources :cates
  resources :items do
    member do
      get :add_cart
    end
  end


  devise_for :managers
  devise_for :users


  root "items#index"

  # 第一層：購物車
  resources :items, :only => [:index, :show]

  # 上面的網址：
  # /statics/action/
  #
  # namespace裡面的網址：
  # dashboard/items/action


  # 第二層：dashboard
  namespace :dashboard do
    resources :orders

    # 第三層：admin
    namespace :admin do
      #現在是教學示例，建議:admin寫成亂碼，像是:sakwejh，這樣才不會被猜到
      # 一個系統在打時，建議從後面打到前面，例如先從管理介面開始打
      resources :items  # 要賣的東西
      resources :cates  # 要賣的東西的分類
      resources :orders # 訂單
      resources :users
      resources :managers
    end
  end

end
