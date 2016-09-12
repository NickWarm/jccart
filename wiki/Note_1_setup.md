## Step.1 環境設定

#### 建立專案
```
rails new JCcart -d mysql -T
```

`-d mysql`代表資料庫選擇用MySQL，`-T`代表不要用rails內建的單元測試

#### 修改database的帳號密碼

我先前設定的MySQL密碼：**iamgroot**，要用時請改成你自己的MySQL密碼

##### JC在影片教學中的寫法，會噴掉 (原因不明)

PS：JC後來也發現會噴掉，不過JC是把defalut的username改成`root`，然後Gemfile把MySQL改成`gem 'mysql2', '0.3.20'`

`config/database.yml`
```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: iamgroot
  password: iamgroot
  host: localhost

  ...

  production:
    <<: *default
    database: JCcart_production
    username: iamgroot
    password: iamgroot

```

##### 我自己修改測試後，能work的寫法
```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: root
  password: iamgroot
  host: localhost

  ...

  production:
    <<: *default
    database: JCcart_production
    username: JCcart
    password: iamgroot

```

#### 會用到的gem

`Gemfile`
關掉`turbolink`、`jbuilder`、`sdoc`、`spring`

安裝
```
gem 'will_paginate'
gem 'awesome_print'
gem 'rails-pry'
gem 'devise'
gem 'paperclip'
```

然後`bundle install`，`rake db:create`，最後`rails s`測試`localhost:3000`看是否能work

## Step.2 路由設定

完整的code

`config/routes.rb`
```rb
Rails.application.routes.draw do

  resources :statics, :only => [:index]
  root "statics#index"

  resources :items, :only => [:index, :show]

  namespace :dashboard do
    resources :orders
    namespace :admin do  
      resources :items  
      resources :cates  
      resources :orders
      resources :users
      resources :managers
    end
  end

end

```
我們會分三層

**第一層：public**

>public是給所有使用者

```
resources :statics, :only => [:index]
root "statics#index"
```

**第一層：購物車**
```
resources :items, :only => [:index, :show]
```

**第二層：dashboard**

>dashboard是給一般使用者

**第三層：admin**

>admin是給管理者

一個系統在打時，建議從後面打到前面，所以我們先從管理介面`:admin`開始打

```
namespace :dashboard do  #第二層
  resources :orders

  namespace :admin do    #第三層
    resources :items  # 要賣的東西
    resources :cates  # 要賣的東西的分類
    resources :orders # 訂單
    resources :users
    resources :managers
  end
end
```

namespace 裡面與外面的code，他的差異在於**路由**

namespace裡面的網址：`dashboard/items/action`

namespace外面的網址：`/statics/action/`

由於我們現在是教學示例，所以admin還是寫`:admin`，但你實際在做商品時，不該這樣寫，會讓你的後台容易被猜到，應該改用亂碼寫，像是`:sakwejh`，所以做商品時，後台路由其實該長這樣
```
namespace :dashboard do
  resources :orders

  namespace :sakwejh do  

    resources :items  # 要賣的東西
    resources :cates  # 要賣的東西的分類
    resources :orders # 訂單
    resources :users
    resources :managers
  end
end
```
