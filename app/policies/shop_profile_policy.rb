class ShopProfilePolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def new?
    current_user.shopkeeper?
  end

  def create?
    current_user.shopkeeper?
  end

  def edit?
    current_user.shop_profiles.exists?(model.id)
  end

  def update?
    current_user.shop_profiles.exists?(model.id)
  end

  def change_status?
    current_user.admin?
  end

  def shop_index?
    current_user.admin?
  end

  def show?
    current_user.shop_profiles.exists?(model.id)
  end

  def index?
    current_user.shop_profiles.exists?(model.id)
  end

  def destroy?
    current_user.shop_profiles.exists?(model.id)
  end  

  def reset?
    current_user.shop_profiles.exists?(model)
  end

end