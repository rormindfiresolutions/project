class UserBasket < ActiveRecord::Base
	belongs_to :user
	has_many :shop_products
	validate :check_unit_type
	validates :quantity, numericality: { greater_than_or_equal_to: 0 }

	# Increases the qunatity of the product by 1
	def self.item_increment item
		item.increment!(:quantity, 1.0)
	end

	private
		def check_unit_type
			if unit_type == 'packet' || unit_type == 'pcs'
				if quantity.to_f - quantity.to_i != 0.0
					errors.add(:quantity, 'Must be an integer')
				end	
			end
		end
		
end