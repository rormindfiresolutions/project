class ProductPolicy
	attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def new?
    current_user.admin?
  end

  def create?
    current_user.admin?
  end

  def index?
  	current_user.shopkeeper?
  end

  def change_status?
  	current_user.admin?
  end

  def change_activation_status?
  	current_user.admin?
  end

  def product_index?
  	current_user.admin?
  end

end
