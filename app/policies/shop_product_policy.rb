class ShopProductPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def index?
  	current_user.shopkeeper?
  end

  def add_to_user_basket?
    ! current_user.shop_profiles.exists?(model.shop_profile_id)
  end
  
end


