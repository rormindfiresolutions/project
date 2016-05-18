class ShopInventory < ActiveRecord::Base
	belongs_to :shop_product
	has_many :shop_inventory_details

	validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
