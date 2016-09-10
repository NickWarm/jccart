## Step.13 購物車的AJAX
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


###

我們對外是用AJAX取這數字，但在此之前我們先建一個helper來取`sessino[:cart]`
