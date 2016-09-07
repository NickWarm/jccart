class CreateCates < ActiveRecord::Migration
  def change
    create_table :cates do |t|

      t.timestamps null: false
    end
  end
end
