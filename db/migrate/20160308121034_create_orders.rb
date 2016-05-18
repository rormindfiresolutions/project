class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.date :order_date
    	t.float :shipping_charge, default: 0
    	t.float :order_value, default: 0
    	t.string :order_state, default: 'new'
      t.references :shop_profile, foreign_key: true
    	t.references :user, foreign_key: true
    	t.references :address, foreign_key: true

      t.timestamps null: false
    end
  end
end
