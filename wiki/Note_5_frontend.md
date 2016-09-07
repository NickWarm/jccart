## Step.7 首頁的頁面
<br>


我們在`localhost:3000/users/sign_up`註冊一個帳號密碼，在此我用

>帳號：wg@wg.wg
><br>
>密碼：wgwgwg

來註冊，註冊後你會看到**Routing Error**，寫說**uninitialized constant StaticsController**，所以現在我們要來去刻首頁的頁面

<br>
### 先看缺什麼

`rake routes`查看我們首頁缺什麼。我們的第一層(root層)只有`statics`與`items`這兩個，所以我們controller要補上`statics#index`與`items#show`、`items#index`。

```
statics GET    /statics(.:format)                           statics#index
   root GET    /                                            statics#index
  items GET    /items(.:format)                             items#index
   item GET    /items/:id(.:format)                         items#show
```

<br>
### statics_controller

create `app/controllers/statics_controller.rb`

完整code
```
class StaticsController < ApplicationController
  def index
    @items = Item.paginate(:page => params[:page])
  end
end
```

一開始我們先
```
class StaticsController < ApplicationController

end
```

然後創建index action，傳統我們是寫
```
def index
  @items = Item.all
end
```

但是由於我們的Index頁面會有很多分頁，所以我們這時就要用到will_paginate這個gem，我們可以去他的[GitHub](https://github.com/mislav/will_paginate)，改成**Basic will_paginate use**那樣的寫法
```
def index
  @items = Item.paginate(:page => params[:page])
end
```

<br>
### items_controller

create `app/controllers/items_controller.rb`

完整code
```
class ItemsController < ApplicationController
  def index
    @items = @paginate = Item.paginate(:page => params[:page])
  end

  def show
    @item = Item.find(params[:id])
  end
end
```

在此要講解一下index action，原本的index action跟`statics_controller.rb`一樣
```
def index
  @items = Item.paginate(:page => params[:page])
end
```

由於下一步，我們要顯示Item的index view，為了要讓前端頁面更好寫，**只要有用分頁的地方，我前面都再加一個`@paginate`**，變成
```
def index
  @items = @paginate = Item.paginate(:page => params[:page])
end
```

同理`statics_controller.rb`也改成
```
class StaticsController < ApplicationController
  def index
    @items = @paginate = Item.paginate(:page => params[:page])
  end
end
```

至於為何要這樣改呢，首先我們回到[will_paginate GitHub](https://github.com/mislav/will_paginate)，一樣看到**Basic will_paginate use**，傳統是寫`<%= will_paginate @posts %>`，但是當你有不同的變數，在我們的專案有`item`、`cate`、`user`、`manager`...，每個都要這樣拉一個，像是`<%= will_paginate @items %>`、`<%= will_paginate @cates %>`...，這樣太累了

原本寫法是這樣

```
<%= will_paginate @posts %>
```

所以我們會多一個變數`@paginate`

一開始寫成
```
<%= if @paginate %>
```

然後改寫成
```
<%= will_paginate @paginate if @paginate %>
```

接著我們就去改`application.html.erb`

fix `views/layouts/application.html.erb`
```
...

<body>

<%= will_paginate @paginate if @paginate %>

<hr>

<%= yield %>

<hr>

<%= will_paginate @paginate if @paginate %>
</body>

...
```

<br>
### 加入登入按鈕

fix `views/layouts/application.html.erb`

完整code
```
<body>

<% if current_user %>
  Hi! <%= current_user.email %>, <%= link_to "登出", destroy_user_session_path, method: "delete" %>
<% else %>
  <%= link_to "登入", new_user_session_path %>, <%= link_to "註冊", new_user_registration_path %>
<% end %>

<%= will_paginate @paginate if @paginate %>

...
```

一開始先是
```
<% if current_user %>

<% else %>

<% end %>
```

`current_user`就是你現在用使用者帳號已經登入了。

這個`current_user`是看你devise先前用什麼model建的，由於我們的devise建了`user`與`manager`，所以我們有`current_user`與`current_manager`可以用

<br>
當我們在`current_user`時，我們可以看到current_user的email
```
<% if current_user %>
  Hi! <%= current_user.email %>  
<% else %>

<% end %>
```

接著我們使用者要登出，首先我們`rake routes`來查看路由，我們看`Controller#Action`這欄位
```
...
destroy_manager_session DELETE /managers/sign_out(.:format)                 devise/sessions#destroy
...
...
...
   destroy_user_session DELETE /users/sign_out(.:format)                    devise/sessions#destroy
...
```

我們要找的是`devise/sessions#destroy`，接著去看他的`Prefix`，由於我們現在是`current_user`，所以登出時是用`destroy_user_session_path`，由於我們把`turbolink`砍掉了，所以我們要用HTML Verb，查看`Verb`可以看到，登出是用`DELETE`

所以code寫成
```
<% if current_user %>
  Hi! <%= current_user.email %>, <%= link_to "登出", destroy_user_session_path, method: "delete" %>
<% else %>

<% end %>
```

`else`內就是沒有登入的狀態，他的路由與上面是相同的概念，就不贅述了

<br>
### 開始來打首頁的內容

create `app/views/statics/index.html.erb`，很簡單打個
```
<h1>我是首頁</h1>
```
然後重整`localhost:3000`測試登入登出畫面。


# 由於JC準備把static砍掉，所以我們準備開新的branch
