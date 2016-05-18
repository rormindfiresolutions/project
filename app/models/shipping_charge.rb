class ShippingCharge < ActiveRecord::Base
	belongs_to :shop_profile

	validates :minimum_order_cost, :maximum_order_cost, overlap: { scope: 'shop_profile_id' }
	validates :minimum_order_cost, numericality: { less_than: :maximum_order_cost }
	validates :minimum_order_cost, numericality: { greater_than: 0 }
	validates :maximum_order_cost, numericality: { greater_than: 0 }
end
