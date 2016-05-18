class AddProductToShopProducts < ActiveRecord::Migration
  def change
    add_reference :shop_products, :product, index: true, foreign_key: true
  end
end
