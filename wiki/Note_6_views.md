## Step.8 把static砍掉，然後用scaffold快速建東西

砍掉`app/controllers/statics_controller`

fix `routes.rb`
```
Rails.application.routes.draw do
  devise_for :managers
  devise_for :users

  root "items#index"

  resources :items, :only => [:index, :show]

  ...
  ...
```

然後修改資料夾名稱，把`app/views/statics`改成`app/views/items`

<br>
### 用scaffold

建立資料夾`app/views/dashboard/admin/items`

然後
```
rails g --help
rails g scaffold --help
```

開始scaffold
```
rails g scaffold items
```
第一個conflict，按N，其他都按enter蓋過去
```
Overwrite /Users/nicholas/Desktop/pracCart/JCcart/app/models/item.rb? (enter "h" for help) [Ynaqdh] n
```

遇到衝突也按enter蓋過去
```
rails g scaffold cates
```

<br>
### 砍掉不要的

然後JC把`views/items`下的檔案全複製到`views/dashboard/admin`，透過在iTerm下指令
```
praccart/jccart/app/views

$ cp -R items dashboard/admin
```

砍掉`views/items`下的`edit.html.erb`、`_form.html.erb`、`new.html.erb`
```
praccart/jccart/app/views/items

rm edit.html.erb
rm _form.html.erb
rm new.html.erb
```

砍掉`views/cates`下的`edit.html.erb`、`_form.html.erb`
```
praccart/jccart/app/views/cates

rm edit.html.erb
rm _form.html.erb
rm new.html.erb
```

<br>
##Step.9 開始修scaffold
<br>

### \_form

fix `app/views/dashboard/admin/items/_form.html.erb`，只留下
```
<div class="actions">
  <%= f.submit %>
</div>
```
### edit

fix `app/views/dashboard/admin/items/edit.html.erb`

完整code
```
<h1>Editing Item</h1>

<%= form_for @item, dashboard_admin_item_path, method: :patch  do |f| %>
  <%= render 'form' %>
<% end %>

<%= link_to 'Show', @item %> |
<%= link_to 'Back', items_path %>
```

先改成這樣，但是他的route是錯的
```
<h1>Editing Item</h1>

<%= form_for @item  do |f| %>
  <%= render 'form' %>
<% end %>

<%= link_to 'Show', @item %> |
<%= link_to 'Back', items_path %>
```

我們`rake routes`，一樣看`Controller#Action`
```
dashboard_admin_items GET    /dashboard/admin/items(.:format)             dashboard/admin/items#index
                      POST   /dashboard/admin/items(.:format)             dashboard/admin/items#create
new_dashboard_admin_item GET    /dashboard/admin/items/new(.:format)         dashboard/admin/items#new
edit_dashboard_admin_item GET    /dashboard/admin/items/:id/edit(.:format)    dashboard/admin/items#edit
 dashboard_admin_item GET    /dashboard/admin/items/:id(.:format)         dashboard/admin/items#show
                      PATCH  /dashboard/admin/items/:id(.:format)         dashboard/admin/items#update
                      PUT    /dashboard/admin/items/:id(.:format)         dashboard/admin/items#update
                      DELETE /dashboard/admin/items/:id(.:format)         dashboard/admin/items#destroy
```

我們在edit頁面，送出表單後會透過HTML動詞`Patch`來update資料，所以我們要找`dashboard/admin/items#update`。我們會看到update沒有`Prefix`可以用，我們就找他的上面一個，也就是`dashboard_admin_item`因為查看`URI Pattern`他們都是在同一層，就能把`form_for`改成
```
<%= form_for @item, dashboard_admin_item_path, method: :patch  do |f| %>
```

### new

fix `app/views/dashboard/admin/items/new.html.erb`

完整code
```
<h1>New Item</h1>

<%= form_for @item, dashboard_admin_items_path, method: :post  do |f| %>
  名稱： <%= f.text_field :name %><br>
  價格： <%= f.number_field :price %>
  <button type="submit" >送出</button>
<% end %>
```

我們一樣是要先看route，我們現在在`new.html.erb`按下submit後會透過HTML動詞`POST`來**create**一筆資料，所以我們要找`dashboard/admin/items#create`。找到後發現沒有`Prefix`，所以找上面一個，找到`dashboard_admin_items`

JC在此手刻了表單內容。

由於原本用scaffold生成的`link_to "Back"`他的路由是錯的，所以就先砍掉。

### fix edit

fix `app/views/dashboard/admin/items/edit.html.erb`
```
<h1>Editing Item</h1>

<%= form_for @item, dashboard_admin_item_path, method: :patch  do |f| %>
  名稱： <%= f.text_field :name %><br>
  價格： <%= f.number_field :price %>
  <button type="submit" >送出</button>
<% end %>
```
由於`link_to 'Show'`、`link_to 'Back'`都是錯的，所以砍掉，表單內容改成先前手刻的

由於都沒用到`_form.html.erb`所以我們就去把他砍掉

delete `app/views/dashboard/admin/items/_form.html.erb`

### fix index

fix `app/views/dashboard/admin/items/index.html.erb`
改成
```
<p id="notice"><%= notice %></p>

<h1>產品列表</h1>

<table>
  <thead>
    <tr>
      <th>id</th>
      <th>名稱</th>
      <th>價格</th>
      <th>管理</th>
    </tr>
  </thead>

  <tbody>
    <% @items.each do |item| %>
      <tr>
        <td><%= item.id %></td>
        <td><%= item.name %></td>
        <td><%= item.price %></td>
        <td>
          <%= link_to '編輯', edit_item_path(item) %>
          <%= link_to '刪除', item, method: :delete, data: { confirm: '你確定嗎?' } %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Item', new_dashboard_admin_item_path %>
```

最後面的`<%= link_to 'New Item', new_item_path %>`他的路由也是錯的，由於我們要建立一個新的item，所以我們`rake routes`去找`dashboard/admin/items#new`相對應的Prefix，也就是`new_dashboard_admin_item`而他是透過Html Verb `Get`，由於這邊是由scaffold生成的，所以我們可以不用給HTML Verb

### 建立dashboard與admin的layout

我們透過在iTerm下指令的方式複製`application.html.erb`然後再去改它
```
jccart/app/views/layouts

ls
>>  application.html.erb

cp application.html.erb dashboard.html.erb
cp application.html.erb admin.html.erb

ls
>> admin.html.erb		application.html.erb	dashboard.html.erb
```

### fix application.html.erb

fix `app/views/layouts/application.html.erb`
```
<body>

<h1>對外頁面:public</h1>

<% if current_user %>

  ...
  ...
  ...
</body>  
```

這麼做的好處是，美工就能對這頁做美化

### fix dashboard.html.erb

fix `app/views/layouts/dashboard.html.erb`

完整code
```
<!DOCTYPE html>
<html>
<head>
  <title>JCcart</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
</head>
<body>

<h1>使用者後台: dashboard</h1>

Hi! <%= current_user.email %>, <%= link_to "登出", destroy_user_session_path, method: "delete" %>

<%= will_paginate @paginate if @paginate %>

<hr>

<%= yield %>

<hr>

<%= will_paginate @paginate if @paginate %>
</body>
</html>

```
由於我們強制要登入，所以一定會有`current_user`可以用，所以delete `current_user判斷式`

### fix admin.html.erb

fix `app/views/layouts/admin.html.erb`

```
<!DOCTYPE html>
<html>
<head>
  <title>JCcart</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
</head>
<body>

<h1>後台頁面：admin</h1>

Hi! <%= current_manager.email %>, <%= link_to "登出", destroy_manager_session_path, method: "delete" %>

<hr>

<ul>
  <li><%= link_to "商品管理", dashboard_admin_items_path %></li>
</ul>

<%= will_paginate @paginate if @paginate %>

<hr>

<%= yield %>

<hr>

<%= will_paginate @paginate if @paginate %>
</body>
</html>
```

要注意：我們現在用的是管理者，所以路由要從`user`改成`manager`，`current_user`要改成`current_manager`

再來是`link_to "商品管理"`。我們要先看到`全部商品`，然後才能做編輯。為了要先看到全部商品，所以我們要去找i`items#index`，所以我們要去路由找`dashboard/admin/items#index`，他的Prefix是`dashboard_admin_items`，這邊一樣是由scaffold生成的，所以不用給HTML Verb  

### 測試剛剛打的頁面是否都能work

##### `localhost:3000`

去`localhost:3000`測試，需要先`rake db:migrate`，然後發現噴了。這是由於scaffold又幫我們建了`20160907072602_create_items.rb`與`20160907073156_create_cates.rb`，但是我們先前已經見過這兩個table了，所以我們下指令刪除它
```
jccart db/migrate

rm 20160907072602_create_items.rb
rm 20160907073156_create_cates.rb
```

然後我們再重整`localhost:3000`的頁面，就能順利work了。

##### `localhost:3000/dashboard/admin/items`

測試時`localhost:3000/dashboard/admin/items`，會發現我們被轉到`localhost:3000/managers/sign_in`，要我們登入manager

我們剛剛manager的帳號密碼

>帳號：wer@wer.wer
>密碼：werwerwer

進去後會發現，我們controller沒有打

### fix admin/items_controller

fix `app/controllers/dashboard/admin/items_controller.rb`

```
class Dashboard::Admin::ItemsController < Dashboard::Admin::AdminController
  def index
    @items = @paginate = Item.paginate(:page => params[:page])
  end
end
```

然後重整頁面，就能順利進入`localhost:3000/dashboard/admin/items`

### fix admin_controller.rb

成功後會發現`h1`tag寫得是`對外頁面：public`，是因為我們少一個語句在controller內

fix `app/controllers/dashboard/admin/admin_controller.rb`
```
class Dashboard::Admin::AdminController < ApplicationController
  before_action :authenticate_manager!
  layout 'admin'
end
```

當我們在` Dashboard::Admin::AdminController`寫上`layout 'admin'`後，所有繼承他的controller，自動變成後台的頁面。

## Step.9 寫一支機器人塞亂數產品進去

裝新的gem `faker`

add `gem "faker"` to `Gemfile`，然後`bundle install`再重開`rails s`。

接著我們去[faker GitHub](https://github.com/stympy/faker)，這是一個塞假資料的gem，JC後來是使用`Faker::Address.state`

先進入console
```
rails c

:001 > Faker
:002 > Item.count
:003 > Item
:004 > 100.times do |i|
:005 >     Item.create(:name => Faker::Address.state, :price => rand(1..3000))
:006?>   end;
:007 >   true
```

然後發現噴了，查看錯誤訊息，是因為少了default的`cate_id`
```
ActiveRecord::StatementInvalid: Mysql2::Error: Field 'cate_id' doesn't have a default value: INSERT INTO `items` (`name`, `price`, `created_at`, `updated_at`) VALUES ('Virginia', 2474, '2016-09-09 08:45:00', '2016-09-09 08:45:00')
```

所以我們再繼續
```
:008 >   100.times do |i|
:009 >     Item.create(:name => Faker::Address.state, :price => rand(1..3000), :cate => cate)
:010?>   end; true
```

就能成功生假資料，接著再去重整`localhost:3000/dashboard/admin/items`就能看到100筆資料，然後我們隨便拿一筆資料按`編輯`，然後發現他又噴了
