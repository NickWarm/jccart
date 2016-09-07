## Step.5 後台的controller

建立`dashboard`、`admin`這兩個資料夾

create `app/controllers/dashboard/admin`

現在我們要一邊看`routes.rb`一邊來建我們的controllers

#### dashboard_controller

create `app/controllers/dashboard/dashboard_controller.rb`


一開始先建立
```
class Dashboard::DashboardController < ApplicationController

end
```

現在來解釋這段，我們可以先下`cmd + p`找到`application_controller.rb`。
```
class ApplicationController < ActionController::Base
```
我們可以看到`application_controller.rb`是繼承自`ActionController::Base`

如果不想被ApplicationController所影響，可以直接繼承ActionController::Base。

為了享有ApplicationController的便利，我們繼承ApplicationController。

這層叫dashboard，所以一開始打dashboard的namespace
```
Dashboard:: < ActionController::Base
```
再來是`dashboard_controller.rb`他的全名
```
Dashboard::DashboardController < ActionController::Base
```

接著我們去[devise GitHub](https://github.com/plataformatec/devise)，看到**Controller filters and helpers**，於是我們在`dashboard_controller.rb`加上
```
before_action :authenticate_user!
```

接下來所有繼承`Dashboard::DashboardController`就不用寫這行，這是他的好處

<br>
#### orders_controller

create `app/controllers/dashboard/orders_controller.rb`

在此，我們就能繼承剛剛的`Dashboard::DashboardController`
```
class Dashboard::OrdersController < Dashboard::DashboardController

end
```

<br>
#### admin_controller

create `app/controllers/dashboard/admin/admin_controller.rb`

這一次，我們在`namespace :admin`這一層，而`namespace :admin`又在`namespace :dashboard`裡面，所以跟`dashboard_controller`一樣的概念，我們繼承自`ApplicationController`
```
class Dashboard::Admin::AdminController < ApplicationController

end
```

一樣驗證，是否有manager進去
```
before_action :authenticate_manager!
```

<br>
#### items_controller

create `app/controllers/dashboard/admin/items_controller.rb`
```
class Dashboard::Admin::ItemsController < Dashboard::Admin::AdminController

end
```
<br><br>
### 以下JC沒打，我就自己先打出來了

<br>
#### cates_controller

create `app/controllers/dashboard/admin/cates_controller.rb`
```
class Dashboard::Admin::CatesController < Dashboard::Admin::AdminController

end
```

<br>
#### cates_controller

create `app/controllers/dashboard/admin/cates_controller.rb`
```
class Dashboard::Admin::CatesController < Dashboard::Admin::AdminController

end
```

<br>
#### orders_controller

create `app/controllers/dashboard/admin/orders_controller.rb`
```
class Dashboard::Admin::OrdersController < Dashboard::Admin::AdminController

end
```

<br>
#### users_controller

create `app/controllers/dashboard/admin/users_controller.rb`
```
class Dashboard::Admin::UsersController < Dashboard::Admin::AdminController

end
```

<br>
#### managers_controller

create `app/controllers/dashboard/admin/managers_controller.rb`
```
class Dashboard::Admin::ManagersController < Dashboard::Admin::AdminController

end
```

<br><br>
#### 建立管理人

進入console建立真正的管理人
```
rails c

:001 > Manager
:002 > Manager.create(:email => 'wer@wer.wer', :password => 'werwerwer')
:003 > exit

```
<br>
登入畫面devise其實已經幫我們弄好了，我們可以`rake routes`來看所有的路由，JC讓我們先來看看`users/sign_up`

`rails s`啟動server後，網址打`localhost:3000/users/sign_up`，會發現噴掉說找不到`turbolinks`，這是因為我們一開始就把`turbolinks`給關掉了

於是我們去`app/views/layouts/application.html.erb`，改成
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

<%= yield %>

</body>
</html>
```

接著去`app/assets/javascripts/application.js`，砍掉`//= require turbolinks`這一行

上一次重啟server是很久以前的事了，為了避免噴掉，去iTerm開啟Server的那個Tab，`Ctrl + c`關掉server後，再`rails s`開啟server，然後去`localhost:3000/users/sign_up`就能看到devise內建的註冊頁面了


####  如何修改devise的登入頁面

剛剛我們連到`localhost:3000/users/sign_up`所看到的頁面是devise的default view，我們可以generate他的view來改成自己想要的

先問rails有什麼可以生成
```
rails g --help
```

然後因為我們有上devise，所以會看到`devise:views`
```
...

Devise:
  devise
  devise:controllers
  devise:install
  devise:views

...
```

所以我們就能下指令生成`devise:views`
```
rails g devise:views
```

我們的`localhost:3000/users/sign_up`是在`app/views/devise/registrations/new.html.erb`

fix `app/views/devise/registrations/new.html.erb`，把標題的`<h2>Sign up</h2>`改成`<h2>Sign up Yooo</h2>`

再重整一次`localhost:3000/users/sign_up`就能看到我們成功改掉標題
