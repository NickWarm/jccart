## Step.8 把static砍掉

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

## 用scaffold，然後改它

建立資料夾`app/views/dashboard/admin/items`

然後
```
rails g --help
rails g scaffold --help
rails g scaffold items
```
