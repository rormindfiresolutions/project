class CreateOrderLines < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
    	t.string :shop_product_name
    	t.float :shop_product_price
    	t.float :quantity
    	t.float :line_value, default: 0
    	t.boolean :is_fulfilled
      t.references :order, foreign_key: true
      t.references :shop_product, foreign_key: true

      t.timestamps null: false
    end
  end
end
