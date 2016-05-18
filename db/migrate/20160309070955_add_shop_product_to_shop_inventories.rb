class AddShopProductToShopInventories < ActiveRecord::Migration
  def change
    add_reference :shop_inventories, :shop_product, index: true, foreign_key: true
  end
end
