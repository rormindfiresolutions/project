class ShopProfileDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view,:user_path
  def_delegator :@view, :select_tag
  def_delegator :@view, :options_for_select
  def_delegator :@view, :shop_profile_path
  def_delegator :@view, :current_user
  def_delegator :@view, :shop_profile_change_status_path

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= %w(shop_profiles.shop_name shop_profiles.email)
  end

  def searchable_columns
    @searchable_columns ||= %w(shop_profiles.shop_name shop_profiles.email)
  end

  private

    def data
      records.map do |record|
        [
          link_to(record.shop_name,shop_profile_path(record)),
          record.users.first.user_profile.first_name,
          record.email,
          record.phone_number,
          [
            if record.is_approved 
              link_to('Disapprove', shop_profile_change_status_path(record), method: :put,
              class: "btn btn-primary light-red") 
            else
              link_to('Approve', shop_profile_change_status_path(record), method: :put, 
              class: "btn btn-primary light-green")
            end
          ]
        ]
      end
    end

    def get_raw_records
      ShopProfile.all
    end
end



