class OrdersController < ApplicationController
	before_action :authenticate_user!

	# To change Order of an User 
	def edit
		@order = Order.find_by(id: params[:id])
		authorize @order
		change_order_state
	end

	def update
	end

	def show
		# To show contents of a particular order
		@order = Order.find_by(id: params[:id])
		authorize @order

		# To download the order in Pdf Format
		user = User.find_by(id: params[:id])
		user_profile = UserProfile.find_by(id: params[:id])
		respond_to do |format|
      format.html
      format.pdf do
       	pdf = WickedPdf.new.pdf_from_string(render_to_string('orders/show.pdf.erb', layout: 'pdf'))
       	send_data(pdf, filename: "#{@order.user.user_profile.first_name}.pdf")
      end
    end
	end

	def index
		# To list all the orders of a Customer with a Filter option
		if current_user.customer?
			if params[:list] =='All'
				@orders = current_user.orders.order(created_at: :desc)
			else
			  @orders = current_user.orders.order(created_at: :desc).where(:created_at => (Time.now - 1.month)..Time.now)
			end

		# To list all the Orders done by Customers of a particular Shop as per Order State(new, in-progress, delivered, closed)
		# To list Own orders of a Shopkeeper ordered from any Shop
		else
			@shop_profile = ShopProfile.find_by(id: params[:shop_profile_id]) or not_found
			order_state = params[:order_state]
			if order_state == 'own'
				@orders = current_user.orders.order(created_at: :desc)
			else
				@orders = @shop_profile.orders.where(order_state: order_state).order(created_at: :desc)
			end
			authorize @shop_profile
		end
		authorize @orders
	end

	# To change the order state to one step ahead for Order state new, in-progress, delivered
	def change_order_state

		# Calling the method changing_order_state from Model
		Order.changing_order_state(@order)			
		
		# Calling the method order_save_after_change from Model
		Order.order_save_after_change(@order, flash)
		redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
	end

	# To change the order state to one step behind for Order state delivered, in-progress
	def revert_order_state
		@order = Order.find(params[:order_id])
		authorize @order
		
		# Calling the method reverting_order_state from Model
		Order.reverting_order_state(@order)			
		
		# Calling the method order_save_after_revert from Model
		Order.order_save_after_revert(@order, flash)	
		redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
	end

	# To cancel the order from Customer side or Shopkeeper side
	def cancel_order
		@order = Order.find(params[:order_id])
		@order.order_lines.each do |product|
			shop_product = ShopProduct.unscoped.where(id: product.shop_product_id).first

			# Calling the method add_cancellation_to_inventory_details from Model
			Order.add_cancellation_to_inventory_details(shop_product, product)
		end
		@order.order_state = 'closed'
		if @order.save
			flash[:success] = 'Order Successfully Cancelled'
			redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
			UserMailer.order_cancellation(User.find(@order.user_id), @order).deliver_now
		else
			flash[:danger] = "Order not Cancelled"
			redirect_to order_path(@order)
		end	
	end
	
end
