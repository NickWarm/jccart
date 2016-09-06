## Step.4 models
<br>

#### Manager model

fix `app/models/manager.rb`
```
class Manager < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable #, :registerable,  #由於管理員不允許被註冊，所以把這段砍掉
        #  :recoverable, :rememberable, :trackable, :validatable
end
```

變成
```
class Manager < ActiveRecord::Base
  devise :database_authenticatable
end

```

<br>
#### User model

fix `app/models/user.rb`
```
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        #  :recoverable, :rememberable, :trackable, :validatable
end
```

變成
```
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable
end
```

<br>
#### Item model


##### 注意！！！
如果要用下指令快速建model，model name後面一定要有欄位名字與型態，例如
```
rails g model Item name:string
```

如果只打`rails g model Item`就會噴掉

在此我們不用以往下指令快速建model的方式，使用JC的手刻寫法

我們一樣去[paperclip github](https://github.com/thoughtbot/paperclip)，看到**Models**那邊，於是我們給`item.rb`加上

add `app/models/item.rb`
```
class Item < ActiveRecord::Base
  has_attached_file :cover,
      styles: {
        original: "1024x1024>",
        medium: "300x300>",
        thumb: "100x100>"
      },  #style很重要，取決於你要幾張圖片
      default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
end

```

style很重要，取決於你要幾張圖片，[RailFun的這篇文章](http://railsfun.tw/t/paperclip/64)就是在講這個

<br>
由於JC忘了在Item加一個分類`cate`所以再寫一個新的migration
```
rails g migration add_item_cate
```

add to `db/migrate/XXXXXX_add_item_cate.rb`
```
add_column :items, :cate_id, :integer, :null => false
```
然後`rake db:migrate`

<br>
接著我們回到`item.rb`，加上
```
class Item < ActiveRecord::Base
  belongs_to :cate

  has_attached_file :cover,
  ...
  ...
end
```

<br>
#### Cate model

create  `app/models/cate.rb`
```
class Cate < ActiveRecord::Base
  has_many :items
end
```

<br>
#### Order model

create `app/models/order.rb`
```
class Order < ActiveRecord::Base
  has_many :order_items
end
```

<br>
#### OrderItem model

create `app/models/order_item.rb`
```
class OrderItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :order
end
```

<br>
#### 進入console測試剛剛建好的model

```
rails c

:001 > Order.count
:002 > Order
:003 > Item
:004 > OrderItem
:005 > User
:006 > Manager
:007 > exit
```

一開始要先`count`，再下Model Name，這樣就能知道這個table是否存在
