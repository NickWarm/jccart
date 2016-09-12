## Step.13 購物車的邏輯
<br>

### 修改對外頁面的畫面

現在我們跳到`localhost:3000/`就能看到最外面的頁面

fix `app/views/items/index.html.erb`
```
<p id="notice"><%= notice %></p>

<h1>Listing Items</h1>

<table>
  <thead>
    <tr>
      <th>圖片</th>
      <th>名稱</th>
      <th>管理</th>
    </tr>
  </thead>

  <tbody>
    <% @items.each do |item| %>
      <tr>
        <td><%= image_tag item.cover.url(:icon) %></td>
        <td><%= item.name %>(<%= item.price %>)</td>
        <td>加入購物車</td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>
```

這邊講一下image_tag，如果我們`url`設為`:icon`，每張圖就會顯示我們先前設定的`150x150`
```
<td><%= image_tag item.cover.url(:icon) %></td>
```

如果我們`url`設為`:original`，圖片就會顯示原始大小
```
<td><%= image_tag item.cover.url(:original) %></td>
```


##### 對外頁面加入分頁效果

由於先前用scaffold沒有分頁，所以我們去controller把頁面改

fix `app/controllers/items_controller.rb`
```
def index
  @items = @paginate = Item .includes(:cate).paginate(:page => params[:page])
end
```

###  購物車的action

加入`add_cart` action

fix `app/controllers/items_controller.rb`
```
before_action :set_item, only: [:show, :edit, :update, :destroy]

def add_cart

end


def index
  ...
end

...
...
```

我們預計加入購物車`add_cart`這個action後，會給我們一個id，所以我們現在要去修改路由

#####  解釋member與collection

fix `routes.rb`，這邊我們先解釋`member`與`collection`
```
Rails.application.routes.draw do

  resources :cates
  resources :items do
    member do
      get :yooo
    end
    collection do
      get :hooo
    end
  end

  ...
  ...
```

我們可以`rake routes`來看他的效果
```
 yooo_item GET    /items/:id/yooo(.:format)                    items#yooo
hooo_items GET    /items/hooo(.:format)                        items#hooo
```

我們可以看到`yooo`有id`hooo`則沒有

`member`一定會有id，`collection`是一個集合體。集合體是什麼，譬如說是首頁、列表頁...，這種綜合體的東西都在collection裡面。一個單一的東西，譬如說某一個產品的頁面，某位使用者的頁面、某類別的頁面，就會有id，就要使用member。


###  add_cart的路由設定

fix `routes.rb`
```
resources :items do
  member do
    get :add_cart
  end
end
```

###  add_cart action 的設計

我們會有一個`params[:id]`在網址內，就像我們在上面解釋`member`會匹配的網址`/items/:id/yooo(.:format)`那樣


fix `app/controllers/items_controller.rb`
```
def add_cart
  session[:cart] || = {}
  item = Item.where(:id => params[:id]).first

  if item
    session[:cart][item.id] ||= 0
    session[:cart][item.id] += 1  
  end

  render :json => {:counter => session[:cart].length}.to_json
end
```

購物車的`session`，一開始
```
session[:cart] || =
```

接下來就依你設計的不同，而使用hash或array寫。用hash會比較好寫，除非你要做「**逛過的足跡**」這種功能才要用array寫
```
session[:cart] || = {}
```

由於我們要取的是`params[:id]`，我們要先驗證有沒有它
```
item = Item.where(:id => params[:id]).first
```

`Item.where()`這一串你把它想成SQL的`WHERE`就很好懂了，他就只是個做判斷式的語法，我們用`where()`判斷出有id，就把他存到`params[:id]` 就把它取出來。

如果有item的話
```
if item
  session[:cart][item.id] ||= 0
  session[:cart][item.id] += 1  
end
```
這是在說，我按一下，數字就`+1`買一個商品，按十次就`+10`買十個商品

最後，我們要回傳
```
render :json => {:counter => session[:cart].length}.to_json
```


### get_cart_count helper

我們對外是用AJAX取這數字，但在此之前我們先建一個helper來取`sessino[:cart]`

fix `app/helpers/application_helper.rb`
```
module ApplicationHelper
  def get_cart_count
    if session[:cart]
      return session[:cart].length
    else
      return 0  
    end
  end
end
```

### 在application中使用get_cart_count helper

fix `app/views/layouts/application.html.erb`
```
<h1>對外頁面:public</h1>
<div>購物車數量<span class="cart_counter"><%= get_cart_count %></span></div>
```

### fix items_controller

然後檢查頁面時發現噴了，大概是因為我的rails版本跟JC不同，我是噴出
```
app/controllers/items_controller.rb:4: syntax error, unexpected '=' session[:cart] || = {} ^
```
檢查良久發現，我在`session[:cart]`的宣告時寫成`|| =`，`||`與`=`之間多一個空格就噴錯了，他們之間不能有空格

fix `app/controllers/items_controller.rb`
```
def add_cart
  session[:cart] ||= {}
  ...
  ...
end
```

### 順手改成JC版的items_controller

由於我的rails沒生成`respond_with`，老實說沒必要改，不過JC都說很多東西用不到，就順手改成JC在影片中的樣子吧

fix `app/controllers/items_controller.rb`

完整的code
```
class ItemsController < ApplicationController

  def add_cart
    session[:cart] ||= {}
    item = Item.where(:id => params[:id]).first

    if item
      session[:cart][item.id] ||= 0
      session[:cart][item.id] += 1
    end

    render :json => {:counter => session[:cart].length}.to_json
  end


  # GET /items
  def index
    @items = @paginate = Item .includes(:cate).paginate(:page => params[:page])
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

end

```

<br>
## Step.14 重頭戲：購物車的AJAX

### 要先挖洞放JavaScript與CSS的地方

fix `app/views/layouts/application.html.erb`  
```
<html>
<head>
  <title>JCcart</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
  <%= yield :header %>
</head>
```

###  剛剛挖好的洞，他的code運作的位置

fix `app/views/items/index.html.erb`
```
<% content_for :header do %>

<% end %>

<h1>Listing Items</h1>

<table>

  ...
  ...
  ...
</table>
```


### 開始寫AJAX

先寫jQuery的語法
```
<% content_for :header do %>
<script>
  jQuery(function($){

  })
</script>
<% end %>
```


用`<a>`來做**加入購物車**的選項
```
<tbody>
  <% @items.each do |item| %>
    <tr>
      ...
      ...
      <td><a href="#" class="add_cart" data-value="<%= item.id %>">加入購物車</a></td>
    </tr>
  <% end %>
```

我們就能用jQuery選取器來選`<a>`的class `add_cart`
```
<script>
  jQuery(function($){
   $('.add_cart').click(function(){

   });
  })
</script>
```

我們要`rake routes`查看網址
```
add_cart_item GET    /items/:id/add_cart(.:format)                items#add_cart
        items GET    /items(.:format)                             items#index
             POST   /items(.:format)                             items#create
     new_item GET    /items/new(.:format)                         items#new
    edit_item GET    /items/:id/edit(.:format)                    items#edit
         item GET    /items/:id(.:format)                         items#show
            PATCH  /items/:id(.:format)                         items#update
              PUT    /items/:id(.:format)                         items#update
           DELETE /items/:id(.:format)                         items#destroy
```

看`URI Pattern`那一欄，我們剛剛談`member`時有說過，要從item的idd去增加購物車數量，所以我們找`/items/:id/add_cart(.:format)`，他的HTML Verb是`GET`

由於我們剛剛在`items_controller`的`add_cart`action最後是傳`json`，他的網址就是我們剛剛查到的`/items/:id/add_cart`
```
<script>
  jQuery(function($){
   $('.add_cart').click(function(){
     $.getJSON('/items/:id/add_cart')
   });
  })
</script>
```

不過由於`:id`是變數，我們要取的是item的`id`，也就是`<a>`下的`data-value="<%= item.id %>"`
```
<script>
  jQuery(function($){
   $('.add_cart').click(function(){
     $.getJSON('/items/' + $(this).attr('data-value') + '/add_cart')
   });
  })
</script>
```

我們預計會得到一個`json`回來，但`json`回來預計要更新到某一個地方
```
<script>
  jQuery(function($){
   $('.add_cart').click(function(){
     $.getJSON('/items/' + $(this).attr('data-value') + '/add_cart', function(json){

     })
   });
  })
</script>
```

這地方就是`localhost:3000/`這頁上面的`購物車數量：0`，我們一樣用chrome工具查看
```
<span class="cart_counter">0</span>
```
於是我們知道，他的class是`cart_counter`

於是
```
<script>
  jQuery(function($){
   $('.add_cart').click(function(){
     $.getJSON('/items/' + $(this).attr('data-value') + '/add_cart', function(json){
      $('#cart_counter').html();
     })
   });
  })
</script>
```

但我們取了的`json`究竟傳了什麼回來呢，我們回去看`app/controllers/items_controller.rb`
```
def add_cart
  session[:cart] ||= {}
  item = Item.where(:id => params[:id]).first

  if item
    session[:cart][item.id] ||= 0
    session[:cart][item.id] += 1
  end

  render :json => {:counter => session[:cart].length}.to_json
end
```

`json`回傳了一個`:counter`的Key，對一個Value `session[:cart].length`。所以我們AJAX得到的`json`就會是
```
$('#cart_counter').html(json.counter);
```

最後記得，如果不要click去觸發event，記得要用`return false;`
```
jQuery(function($){
 $('.add_cart').click(function(){
   $.getJSON('/items/' + $(this).attr('data-value') + '/add_cart', function(json){
    $('#cart_counter').html(json.counter);
  });

  return false;
 });
})
</script>
```
如果沒用`return false;`，他會觸發`<a href="#">`導致我們重新讀一次這個頁面

### 解購物車沒即時AJAX的蟲

重整頁面後，按了幾次`加入購物車`沒反應，重整後才發現購物車數字有增加，抓了許久蟲後發現，`application.html.erb`我要AJAX的`span`應該用`#cart_counter`我卻寫成`.cart_counter`

fix `app/views/layouts/application.html.erb`

from

```
<h1>對外頁面:public</h1>
<div>購物車數量：<span class="cart_counter"><%= get_cart_count %></span></div>
```

to

```
<h1>對外頁面:public</h1>
<div>購物車數量：<span id="cart_counter"><%= get_cart_count %></span></div>
```

###  購物車數字怪怪的問題

我們可以debug他，把它印出來

add to `app/views/layouts/application.html.erb`
```
<h1>對外頁面:public</h1>
<div>購物車數量：<span id="cart_counter"><%= get_cart_count %></span></div>
<br>
<%= session[:cart] %>
```

然後我們去看`localhost:3000/`的最上面可看到

```
{"1"=>9, "2"=>3, "3"=>1, "4"=>1}
```
從印出的畫面我們知道，`session[:cart]`的key是string，所以我們應該要把`session[:cart]`的key都轉成string

fix `app/controllers/items_controller.rb`

from

```
  if item
    session[:cart][item.id] ||= 0
    session[:cart][item.id] += 1  
  end
```

to

```
if item
  key = item.id.to_s
  session[:cart][key] ||= 0
  session[:cart][key] += 1
end
```

###  改掉用table顯示商品的寫法，加上CSS

fix `app/views/items/index.html.erb`

```
<% content_for :header do %>
<style>
  ul.items, ul.items li{
    list-style: none;
    padding: 0;
    margin: 0;
  }
</style>

<script>
...
...
```

原本的`table`這寫法很醜，通常上production會拆成`ul`跟`li`

fix `app/views/items/index.html.erb`

from

```
<table>
  <thead>
    <tr>
      <th>圖片</th>
      <th>名稱</th>
      <th>管理</th>
    </tr>
  </thead>

  <tbody>
    <% @items.each do |item| %>
      <tr>
        <td><%= image_tag item.cover.url(:icon) %></td>
        <td><%= item.name %>(<%= item.price %>)</td>
        <td><a href="#" class="add_cart" data-value="<%= item.id %>">加入購物車</a></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

to

```
<ul class="items">
  <% @items.each do |item| %>
    <li>
      <%= image_tag item.cover.url(:icon) %>
      <span class="name"><%= item.name %>(<%= item.price %>)</span>
      <a href="#" class="add_cart" data-value="<%= item.id %>">加入購物車</a>
    </li>
  <% end %>
</ul>
```

接著我們繼續改CSS
```css
<style>
  ul.items, ul.items li{
    list-style: none;
    padding: 0;
    margin: 0;
  }

  ul.items li{
    display: block;
    float: left;
    border: 1px #ccc solid;
    border-radius: 6px;
    width: 120px;
    height: 180px;
    margin: 4px 0 0 4px;
    text-align: center;
  }

  ul.items li img{
    width: 120px;
    height: 120px;
    display: block;
    border-radius: 8px;
  }

  ul.items li .name{
    display: block;
  }

  ul.items li a{
    display: inner-block;
    background: #ccccff;
    padding: 4px 8px;
    border-radius: 3px;
  }
</style>
```

然後重整`localhost:3000`，work!!!  

由於時間不夠，沒實作串金流，只有口述，請看影片[2:36:24](https://youtu.be/r2sLYTQwgtQ?t=9384)，可看[tienshunlo的筆記](http://tienshunlo-blog.logdown.com/posts/711622-25d-shopping-cart)

# 結束 ^_^
