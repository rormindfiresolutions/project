class AddShopProductToShopInventoryDetails < ActiveRecord::Migration
  def change
    add_reference :shop_inventory_details, :shop_product, index: true, foreign_key: true
  end
end
