class CreateShippingCharges < ActiveRecord::Migration
  def change
    create_table :shipping_charges do |t|
    	t.float :minimum_order_cost
    	t.float :maximum_order_cost
    	t.float :shipping_cost
    	t.references :shop_profile
      t.timestamps null: false
    end
  end
end