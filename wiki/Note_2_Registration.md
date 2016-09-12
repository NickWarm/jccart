## Step.3 註冊系統
<br><br>


使用`devise`這個gem，[devise GitHub](https://github.com/plataformatec/devise)

先在我們的專案裝好devise
```
rails g devise:install
```

接著我們需要devise的User model以及Manager model
```
rails g devise User  
rails g devise Manager
```

接著去修改`XXXXXXX_devise_create_users.rb`，JC解釋了這些功能，然後把`Recoverable`、`Rememberable`、`Trackable`、`Confirmable`、`Lockable`，以及下面這行都註解掉沒使用它們

`db/migrate/20160906083955_devise_create_users.rb`
```rb
  # add_index :users, :reset_password_token, unique: true
```

接著去修改`XXXXXXX_devise_create_manager.rb`，一樣關掉上面那些東西。

然後`rake db:migrate`
<br><br>
### 建立shop的table

```
rails g migration init_shop
```

add to `migrate/XXXXXX_init_shop.rb`
```rb
class InitShop < ActiveRecord::Migration
  def change
    create_table :cates do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end

    create_table :items do |t|
      t.integer :status, :limit => 1, :default => 0, :null => false
      t.string :name
      t.integer :price
      t.text :descript
      t.timestamps
      t.timestamp :delete_at #當你刪掉一筆訂單時，你並不是真正刪掉，只是讓數字少1，他會保留你原始的資料，方便你追帳
    end

    create_table :orders do |t|
      t.integer :user_id
      t.timestamps
      t.integer :status, :limit => 1, :null => false, :default => 0
      t.integer :total, :default => 0, :null => false
    end

    create_table :order_items do |t|
      t.integer :order_id, :null => false
      t.integer :item_id, :null => false
      t.integer :user_id, :null => false
      t.integer :price, :null => false
    end
    add_index :order_items, [:order_id] #所有可能用到WHERE的都要加到add_index裡去
  end
end
```

##### 待補充：要解釋這些table

然後`rake db:migrate`

<br>
### 產品圖片：paperclip


使用[paperclip github](https://github.com/thoughtbot/paperclip)


```
brew install imagemagick
```
裝完後可以用`convert --help`這指令問ImageMagick有什麼東西可以用

接著去`Gemfile`加入ImageMagick`gem "paperclip", "~> 5.0.0"`，由於我們剛剛已經裝過，所以這行可省略

然後JC解釋了[paperclip github](https://github.com/thoughtbot/paperclip)，**Migration** 的部分

```
rails g migration add_item_cover
```

然後把`XXXXXXX_add_item_cover.rb`修改成[paperclip github](https://github.com/thoughtbot/paperclip)，**Migration** 的寫法

`db/migrate/20160906094234_add_item_cover.rb`
```rb
class AddItemCover < ActiveRecord::Migration
  def up
    add_attachment :items, :cover
  end

  def down
    remove_attachment :items, :cover
  end
end
```

然後再一次`rake db:migrate`
