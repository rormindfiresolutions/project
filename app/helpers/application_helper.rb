module ApplicationHelper
  def new_tasks_count
    count = 0
    current_user.shop_profiles.each do |shop_profile|
      count += shop_profile.orders.where(order_state: 'new').count
    end
    count
  end

  def in_progress_tasks_count
    count = 0
    current_user.shop_profiles.each do |shop_profile|
     count += shop_profile.orders.where(order_state: 'in-progress').count
    end
    count
  end

  def total_tasks_count
    count = new_tasks_count + in_progress_tasks_count
  end

  def user_basket_items_count
    (UserBasket.where("user_id = ?", current_user.id)).count
  end

  def cp(path)
    "current" if current_page?(path)
  end
end           


