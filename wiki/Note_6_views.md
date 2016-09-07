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
