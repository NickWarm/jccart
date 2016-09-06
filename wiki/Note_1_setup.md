
# RailsFun Day2.5 JC的購物車教學
影片：[RailsFun Day2.5 購物車](https://www.youtube.com/watch?v=r2sLYTQwgtQ)

別人的筆記：[2.5D購物車 « tienshunlo's Blog](http://tienshunlo-blog.logdown.com/posts/711622-25d-shopping-cart)

## Step.1 環境設定

#### 建立專案
```
rails new JCcart -d mysql -T
```

`-d mysql`代表資料庫選擇用MySQL，`-T`代表不要用rails內建的單元測試

#### 修改database的帳號密碼

我先前設定的MySQL密碼：iamgroot

##### JC在影片教學中的寫法，會噴掉 (原因不明)
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
