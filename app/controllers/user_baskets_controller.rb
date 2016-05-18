class UserBasketsController < ApplicationController
	include UserBasketHelper
	def create
		shop_product = ShopProduct.find_by(id: params[:id]) or not_found
		shop_profile = ShopProfile.find_by(id: params[:id])
		item = UserBasket.where(shop_product_id: shop_product.id, user_id: current_user.id).first

		if shop_product.shop_inventory.quantity == 0
			flash[:danger] = 'Insufficient Quantity'
			redirect_to request.referrer  and return
		end

		# increases the qunatity if products pre exists in the user_basket
		if item
			UserBasket.item_increment(item)
			save_user_basket(item)

		else
			@user_basket = UserBasket.new
			@user_basket = current_user.user_baskets.build
			@user_basket.quantity = 1
			@user_basket.shop_product_id = shop_product.id
			@user_basket.unit_type = shop_product.unit_type
			@user_basket.shop_profile_id = shop_product.shop_profile.id
			save_user_basket(@user_basket)
		end

	end

	def edit
		if current_user.user_baskets.empty?
			flash[:error] = 'Your Cart is Empty'
			redirect_to root_path
		else
			@user_baskets = UserBasket.all.where(user_id: current_user.id)
		end
	end

	def edit_quantity
		@user_basket = UserBasket.find(params[:id])
		@shop_product = ShopProduct.find_by(id: @user_basket.shop_product_id)
	end

	# for changing the qunantity of a product in user_basket
	def update_quantity
		@user_basket = UserBasket.find(params[:id])
		@shop_product = ShopProduct.find_by(id: @user_basket.shop_product_id)
	  @user_basket.quantity = params[:user_basket][:quantity].to_f

	  # for checking quantity exists in shop_inventory
	  if @shop_product.shop_inventory.quantity - @user_basket.quantity < 0
			flash[:danger] = 'Insufficient Quantity'
			redirect_to edit_user_basket_path  and return
		end

		if (@shop_product.unit_type == 'packet' or @shop_product.unit_type == 'pcs') and 
			@user_basket.quantity % 1 != 0
			flash[:danger] = 'Please enter whole numbers for packed products'
			redirect_to edit_user_basket_path and return
		end

		if @user_basket.update_attributes(user_baskets_params)
			flash[:success] = 'Quantity Updated'
			redirect_to edit_user_basket_path
		else
		  flash[:danger] = 'Not Updated'
			redirect_to edit_user_basket_path
		end	
	end

	# removing items form user_basket
	def destroy
		@user_basket = UserBasket.find(params[:id])
		@shop = ShopProfile.find(@user_basket.shop_profile_id);
		@price = ShopProduct.find(@user_basket.shop_product_id).selling_price
		@price *= @user_basket.quantity
		@user_basket.destroy
		if current_user.user_baskets.empty?
			respond_to do |format|
      	format.html { redirect_to root_path }
      	format.js {}
	    end
		else
			respond_to do |format|
      	format.html { redirect_to request.referer || root_path }
      	format.js {}
	    end
		end
	end

	private

		def user_baskets_params
			params.require(:user_basket).permit(:quantity, :user_id, :shop_product_id, :shop_profile_id, :shipping_cost)
		end

		# adds product to user_basket
		def save_user_basket(item)
			if item.save 
				flash[:success] = 'Product Added to Cart'
				respond_to do |format|
	      	format.html { redirect_to request.referer || root_path }
	      	format.js {}
		    end
			else
				flash[:error] = 'Product not Added'
				redirect_to request.referrer || root_path
			end
		end
		
end
