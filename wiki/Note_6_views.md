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

然後JC把`views/items`下的檔案全複製到`views/dashboard/admin`，透過在iTerm下指令
```
praccart/jccart/app/views

$ cp -R items dashboard/admin
```

砍掉`views/items`下的`edit.html.erb`、`_form.html.erb`
```
praccart/jccart/app/views/items

rm edit.html.erb
rm _form.html.erb
```
