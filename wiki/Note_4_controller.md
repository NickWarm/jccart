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
#### 建立管理者

```
rails c
```
