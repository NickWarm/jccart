class AddItemCover < ActiveRecord::Migration
  def up
    add_attachment :items, :cover
  end

  def down
    remove_attachment :items, :cover
  end
end
