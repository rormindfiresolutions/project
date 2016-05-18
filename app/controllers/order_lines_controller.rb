class OrderLinesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_user_profile, only: :create
	before_action :check_address, only: :create
	include OrderHelper

	def new
		authorize OrderLine
	end

	def create
		authorize OrderLine
		order_array = Array.new
		address_id = params[:address]
		current_user.user_baskets.each do |product|
			shop_product = ShopProduct.find_by(id: product.shop_product_id)

			if shop_product.shop_inventory.quantity - product.quantity < 0
				flash[:danger] = 'Insufficient Quantity'
				redirect_to root_path and return
			end

			# Calling the method add_order_to_inventory_details from Model
			OrderLine.add_order_to_inventory_details(shop_product, product, current_user)
			@order_line = OrderLine.new

			# To Create a Order Line
			@order_line.quantity = product.quantity
			@order_line.shop_product_name = shop_product.product_name
			@order_line.shop_product_price = shop_product.selling_price
			@order_line.is_fulfilled = false
			@order_line.line_value = @order_line.shop_product_price * @order_line.quantity
			@order_line.shop_product_id = shop_product.id
			order_placed = false
			if !order_array.empty?
				order_array.each do |order|
					if order.shop_profile_id == shop_product.shop_profile_id
						order.address_id = address_id
						order.shop_profile_id = shop_product.shop_profile_id
						order.order_lines << @order_line
						order.order_value += @order_line.line_value
						order_placed = true
						break
					end
				end
			end
			
			# To Create Order Line for different Shop Profile if Ordered from Multiple Shop Profiles
			if  order_array.empty? || !order_placed
				new_order = current_user.orders.build
				new_order.address_id = address_id
				new_order.shop_profile_id = shop_product.shop_profile_id
				new_order.order_lines << @order_line
				new_order.order_value += @order_line.line_value
				order_array << new_order
			end

			product.destroy
		end

		if !order_array.empty?
			order_array.each do |order|
				shop_profile = ShopProfile.find(order.shop_profile_id)
				if shop_profile.shipping_charges.exists?
					order.shipping_charge = shipping_charge(order)
				else
					order.shipping_charge = 0
				end
				order.order_value = order.order_value + order.shipping_charge
				order.save
				UserMailer.order_information(current_user, order.order_lines).deliver_now
			end
			flash[:success] = 'Your Order has been Placed'
			redirect_to root_path
		else
			flash[:danger] = 'Error While Placing Your Order'
			redirect_to new_order_line_path
		end
	end
	
	private

		def check_user_profile
			if current_user.user_profile.nil?
				flash[:error] = 'Please provide with Personal Information'
				redirect_to new_user_profile_path
			end
		end

		def check_address
			if current_user.addresses.first.nil?
				flash[:error] = 'Enter an Address for Delivering'
				redirect_to new_address_path
			end
		end

end