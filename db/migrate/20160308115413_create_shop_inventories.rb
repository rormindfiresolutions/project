class CreateShopInventories < ActiveRecord::Migration
  def change
    create_table :shop_inventories do |t|
    	t.float :quantity, default: 0

      t.timestamps null: false
    end
  end
end