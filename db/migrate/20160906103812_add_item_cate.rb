class AddItemCate < ActiveRecord::Migration
  def change
    add_column :items, :cate_id, :integer, :null => false
  end
end
