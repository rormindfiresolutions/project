class CreateShopProfiles < ActiveRecord::Migration
  def change
    create_table :shop_profiles do |t|
    	t.string :shop_name
    	t.string :phone_number
    	t.string :email
      t.boolean :is_approved, default: false
    	t.references :address, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :shop_profiles_users do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :shop_profile, index: true
    end
  end
end
