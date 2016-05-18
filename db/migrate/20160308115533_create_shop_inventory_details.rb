class CreateShopInventoryDetails < ActiveRecord::Migration
  def change
    create_table :shop_inventory_details do |t|
    	t.string :inventory_type
    	t.string :notes
    	t.float :quantity, default: 0
    	t.references :shop_inventory, foreign_key: true
    	t.references :shop_profile, foreign_key: true

      t.timestamps null: false
    end
  end
end
