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

###  加入購物車

fix `app/controllers/items_controller.rb`
