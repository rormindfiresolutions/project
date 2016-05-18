class AddCategoryToShopProducts < ActiveRecord::Migration
  def change
    add_reference :shop_products, :category, index: true, foreign_key: true
  end
end
