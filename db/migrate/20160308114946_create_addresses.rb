class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
    	t.string :address_type
    	t.string :name
    	t.string :address_1
    	t.string :address_2
    	t.string :city
    	t.string :state
    	t.integer :pincode
    	t.string :landmark
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
