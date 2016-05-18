class AddAddressToShopProfiles < ActiveRecord::Migration
  def change
  	add_reference :addresses, :shop_profile, index: true, foreign_key: true
  end
end
