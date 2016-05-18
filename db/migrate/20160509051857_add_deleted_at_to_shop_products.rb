class AddDeletedAtToShopProducts < ActiveRecord::Migration
  def change
    add_column :shop_products, :deleted_at, :datetime
    add_index :shop_products, :deleted_at
  end
end
