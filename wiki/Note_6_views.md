## Step.8 把static砍掉，然後用scaffold快速建東西
<br>

砍掉`app/controllers/statics_controller`

fix `routes.rb`
```rb
Rails.application.routes.draw do
  devise_for :managers
  devise_for :users

  root "items#index"

  resources :items, :only => [:index, :show]

  ...
  ...
```

然後修改資料夾名稱，把`app/views/statics`改成`app/views/items`


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
## Step.9 開始修scaffold
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
```html
<h1>Editing Item</h1>

<%= form_for @item, dashboard_admin_item_path, method: :patch  do |f| %>
  <%= render 'form' %>
<% end %>

<%= link_to 'Show', @item %> |
<%= link_to 'Back', items_path %>
```

先改成這樣，但是他的route是錯的
```html
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
```html
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
```html
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
```html
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
```html
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

```rb
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

##### 頁面：`localhost:3000`

去`localhost:3000`測試，需要先`rake db:migrate`，然後發現噴了。這是由於scaffold又幫我們建了`20160907072602_create_items.rb`與`20160907073156_create_cates.rb`，但是我們先前已經見過這兩個table了，所以我們下指令刪除它
```
jccart db/migrate

rm 20160907072602_create_items.rb
rm 20160907073156_create_cates.rb
```

然後我們再重整`localhost:3000`的頁面，就能順利work了。

##### 頁面：`localhost:3000/dashboard/admin/items`

測試時`localhost:3000/dashboard/admin/items`，會發現我們被轉到`localhost:3000/managers/sign_in`，要我們登入manager

我們剛剛manager的帳號密碼

>帳號：wer@wer.wer
>密碼：werwerwer

進去後會發現，我們controller沒有打

### fix admin/items_controller

fix `app/controllers/dashboard/admin/items_controller.rb`

```rb
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
```rb
class Dashboard::Admin::AdminController < ApplicationController
  before_action :authenticate_manager!
  layout 'admin'
end
```

當我們在` Dashboard::Admin::AdminController`寫上`layout 'admin'`後，所有繼承他的controller，自動變成後台的頁面。

<br>
## Step.10 寫一支機器人塞亂數產品進去
<br>

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
ActiveRecord::StatementInvalid: Mysql2::Error: Field 'cate_id' doesn't have a default value:
            INSERT INTO `items` (`name`, `price`, `created_at`, `updated_at`)
            VALUES ('Virginia', 2474, '2016-09-09 08:45:00', '2016-09-09 08:45:00')
```

所以我們再繼續
```
:008 >   100.times do |i|
:009 >     Item.create(:name => Faker::Address.state, :price => rand(1..3000), :cate => cate)
:010?>   end; true
```

就能成功生假資料，接著再去重整`localhost:3000/dashboard/admin/items`就能看到100筆資料，然後我們隨便拿一筆資料按`編輯`，然後發現他又噴`Template is missing`

### fix admin/items_controller

fix `app/controllers/dashboard/admin/items_controller.rb`
```rb
class Dashboard::Admin::ItemsController < Dashboard::Admin::AdminController
  def index
    @items = @paginate = Item.order('id DESC').paginate(:page => params[:page])
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    @item.save
    redirect_to action: :index #這是舊版寫法
    #新版寫法  redirect_to dashboard_admin_items_path
  end

  def update
    @item.update(item_params)
    redirect_to action: :index
  end

  def destroy
    @item.destroy
    redirect_to action: :index
  end
end

private

def item_params
  params.require(:item).permit!
end

```

通常後台會倒序排序，所以會寫`Item.order('id DESC').paginate(:page => params[:page])`

接著再按`編輯`，發現又噴了，查看錯誤訊息，是先前`index.html.erb`的route寫錯

### fix admin/items/index.html.erb

fix `app/views/dashboard/admin/items/index.html.erb`

原本是
```
<%= link_to '編輯', edit_item_path(item) %>
```

查看route，應該是要走到`dashboard/admin/items#edit`，查看Prifx應該是`edit_dashboard_admin_item`，所以我們改成
```
<%= link_to '編輯', edit_dashboard_admin_item_path(item) %>
```

delete原本的路由也是錯的，改成
```
<%= link_to '刪除', dashboard_admin_item_path(item), method: :delete, data: { confirm: '你確定嗎?' } %>
```

### fix admin/items/edit.html.erb

重整頁面再按一次`編輯`，然後又噴了，錯誤訊息是寫`form_for`有問題，所以辜狗去查[rails api form_for](http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for)

這邊都會把form_for怎麼用講得很清楚，我們去看form_for傳的url參數，發現是傳`:url`，所以我們回去改

fix `app/views/dashboard/admin/items/edit.html.erb`
```
<%= form_for @item, :url => dashboard_admin_item_path, method: :patch  do |f| %>
  ...
  ...
<% end %>
```

接著再重整頁面，然後按`編輯`，終於能work了

### fix dashboard/admin/items_controller

接著，我們隨便找一個來編輯，改掉價格後送出，又噴`undefined method "update" for nil:NilClass`，是因為我們在controller的`upeate action`沒有宣告`@item`

fix `app/controllers/dashboard/admin/items_controller.rb`
```
def update
  @item = Item.find(params[:id])
  ...
end
```

眼角餘光掃到`destroy action`也沒有，一樣加上`@item = Item.find(params[:id])`

<br>
## Step.11 加上圖片
<br>

### fix admin/items/edit.html.erb

fix `app/views/dashboard/admin/items/edit.html.erb`
```html
<h1>Editing Item</h1>

<%= form_for @item, :url => dashboard_admin_item_path, method: :patch  do |f| %>
  名稱： <%= f.text_field :name %><br>
  價格： <%= f.number_field :price %><br>
  圖片： <%= f.file_field :cover %><br>
  <button type="submit" >送出</button>
<% end %>
```

### fix admin/items/index.html.erb

為了讓圖片顯示出來，列表下也有必要有圖片

fix `app/views/dashboard/admin/items/index.html.erb`
```html
<h1>產品列表</h1>

<table>
  <thead>
    <tr>
      <th>id</th>
      <th>圖片</th>
      ...
      ...
    </tr>
  </thead>

  <tbody>
    <% @items.each do |item| %>
      <tr>
        <td><%= item.id %></td>
        <td><%= image_tag item.cover.url(:icon) %></td>
        ...
        ...
        ...
      </tr>
    <% end %>
  </tbody>
</table>
```

### 設定missing.jpg

然後重整`localhost:3000/dashboard/admin/items`，我們可以看到index view裡所有圖片都是missing，我們用chrome工具檢查元素，可以看到預設是使用`/images/icon/missing.png`
```
<img src="/images/icon/missing.png" alt="Missing">
```

所以我們去辜狗找一張圖片來放吧，我使用的是[icon-question](http://missingmiddlehousing.com/wp-content/uploads/2015/04/icon-question.png)這張圖片

先創建資料夾，create `jccart/public/images/icon`

然後把剛剛抓的圖片放到這資料夾下，並且改名為`missing.png`
```
jccart/public/images/icon

mv icon-question.png missing.jpg
```

### fix iterm model 來改變圖片設定

現在我們把icon設定成`jpg`檔，可是我們剛剛用chrome工具查到的是使用`png`檔，我們可以去iterm model改他

fix `app/models/iterm.rb`
```rb
class Item < ActiveRecord::Base
  belongs_to :cate

  has_attached_file :cover,
      styles: {
        original: "1024x1024>",
        cover: "300x300>",
        icon: "150x150#"
      },  #style很重要，取決於你要幾張圖片
      default_url: "/images/missing.jpg"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
end
```

原本的`default_url`如下
```
default_url: "/images/:style/missing.jpg"
```
這樣的寫法是從`style`裡取`icon`

現在我們把它拿掉變成
```
default_url: "/images/missing.jpg"
```

所以我們也要把`missing.jpg`他的路徑從`public/images/icon/missing.jpg`改成`public/images/missing.jpg`，然後再重整`localhost:3000/dashboard/admin/items`，我們的圖片就能work了

### 在view裡設定圖片大小

由於我一開始找的圖片就是`150x150`沒法體會到太大張的困擾，所以我們來找第二張圖片玩玩吧。我找了一個`200x200`的[X圖片](https://d30y9cdsu7xlg0.cloudfront.net/png/275465-200.png)，然後命名為`missing2.jpg`

一樣去改`app/models/iterm.rb`，改成`efault_url: "/images/missing2.jpg"`，然後再重整`localhost:3000/dashboard/admin/items`，可以明顯感受到他圖片變大了

接著我們去修改`app/views/dashboard/admin/items/index.html.erb`
```html
<tbody>
  <% @items.each do |item| %>
    <tr>
      <td><%= item.id %></td>
      <td><%= image_tag item.cover.url(:icon), :width => 150, :height => 150 %></td>
      ...
      ...
</tbody>
```
再重整`localhost:3000/dashboard/admin/items`，圖片順利變小

###  測試上傳圖片

在index view下，隨意點選一筆資料按下編輯，然後上傳圖片，確定能work。

<br>
## Step.12  類別的下拉選單
<br>

接下來的**使用者管理**、**類別管理**，都是一樣的寫法去寫，現在要教如何製作快一點的類別管理，我們先做一個產生器
```
rails c

:001 > 10.times do |i|
:002 >     Cate.create(:name => Faker::Pokemon.name)
:003?>   end; true
```

如此我們就建了十個類別。

### 下拉式選單的奇淫技巧 f.select

這邊要教用`f.select`來做下拉式選單

fix `app/views/dashboard/admin/items/edit.html.erb`
```
<%= form_for @item, :url => dashboard_admin_item_path, method: :patch  do |f| %>
  ...
  ...
  ...
  類別： <%= f.select Cate.all.map{|c|[c.name, c.id]} %>

  <button type="submit" >送出</button>
<% end %>
```

這邊解釋一下`Cate.all.map{|c|[c.name, c.id]}`這段，用`f.select`生成的下拉式選單，他其實是要放一個array，array裡包值`[["名稱", value]]`

然後點選`編輯`，發現又噴了，JC下辜狗關鍵字`rails helper select form`，點選[ActionView::Helpers::FormBuilder](http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html)然後看裡面的[select](http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select)，發現少給了name，於是改成
```
類別： <%= f.select :cate_id, Cate.all.map{|c|[c.name, c.id]} %>
```

然後重整進入`編輯`頁面，就能看到漂亮的下拉選單了。我們一樣能用chrome工具檢查元素查看
```html
<select name="item[cate_id]" id="item_cate_id"><option selected="selected" value="1">大雜燴</option>
<option value="2">Omanyte</option>
<option value="3">Golbat</option>
<option value="4">Pidgeotto</option>
<option value="5">Nidoking</option>
<option value="6">Dragonair</option>
<option value="7">Blastoise</option>
<option value="8">Exeggutor</option>
<option value="9">Vulpix</option>
<option value="10">Magnemite</option>
<option value="11">Geodude</option></select>
```

可以看到`name`傳了一個array進去，而`option`有著用faker生成的`各種Pokemon name`與`value`

### n+1 query

完成下拉選單後，我們給幾筆資料加入類別後送出，接著我們要給頁面顯示類別，但這會有一個**n+1 query**的問題，我們直接上code來看吧

fix `views/dashboard/admin/items/index.html.erb`
```html
<table>
  <thead>
    <tr>
      <th>id</th>
      <th>類別</th>
      ...
      ...
    </tr>
  </thead>

  <tbody>
    <% @items.each do |item| %>
      <tr>
        <td><%= item.id %></td>
        <td><%= item.cate.name %></td>
        ...
        ...
        ...
      </tr>
    <% end %>
  </tbody>
</table>
```

然後我們去`localhost:3000/dashboard/admin/items`就能看到剛剛輸入的類別了，接下來我們去跑`rails s`的那個iTerm tab查看他的log，可以看到像下面的code
```sql
Started GET "/dashboard/admin/items" for ::1 at 2016-09-09 22:09:00 +0800
Processing by Dashboard::Admin::ItemsController#index as HTML
  Manager Load (0.3ms)  SELECT  `managers`.* FROM `managers` WHERE `managers`.`id` = 1  ORDER BY `managers`.`id` ASC LIMIT 1
  Item Load (0.3ms)  SELECT  `items`.* FROM `items`  ORDER BY id DESC LIMIT 30 OFFSET 0
   (0.2ms)  SELECT COUNT(*) FROM `items`
  Cate Load (0.2ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 2 LIMIT 1
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 2 LIMIT 1  [["id", 2]]
  Cate Load (0.2ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 4 LIMIT 1
  Cate Load (0.3ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 3 LIMIT 1
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 3 LIMIT 1  [["id", 3]]
  Cate Load (0.4ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.1ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  `cates`.* FROM `cates` WHERE `cates`.`id` = 1 LIMIT 1  [["id", 1]]
  Rendered dashboard/admin/items/index.html.erb within layouts/admin (38.0ms)
Completed 200 OK in 65ms (Views: 61.2ms | ActiveRecord: 2.4ms)
```

這個是跑index view時，為了查詢類別所花的時間，當你類別越多花的時間越多，這就是`n+1 query`是很嚴重的效能問題，他的解法在controller內

###  fix admin/items_controller

fix `app/controllers/dashboard/admin/items_controller.rb`
```
def index
  @items = @paginate = Item.order('id DESC').includes(:cate).paginate(:page => params[:page])
end
```

然後重整`localhost:3000/dashboard/admin/items`，再去查看log
```sql
Started GET "/dashboard/admin/items" for ::1 at 2016-09-09 22:20:40 +0800
Processing by Dashboard::Admin::ItemsController#index as HTML
  Manager Load (0.2ms)  SELECT  `managers`.* FROM `managers` WHERE `managers`.`id` = 1  ORDER BY `managers`.`id` ASC LIMIT 1
  Item Load (0.5ms)  SELECT  `items`.* FROM `items`  ORDER BY id DESC LIMIT 30 OFFSET 0
  Cate Load (5.0ms)  SELECT `cates`.* FROM `cates` WHERE `cates`.`id` IN (2, 4, 3, 1)
   (0.4ms)  SELECT COUNT(*) FROM `items`
  Rendered dashboard/admin/items/index.html.erb within layouts/admin (43.7ms)
Completed 200 OK in 99ms (Views: 75.0ms | ActiveRecord: 9.8ms)
```

這樣就很漂亮，只用了幾行SQL就取出了我們要的類別
