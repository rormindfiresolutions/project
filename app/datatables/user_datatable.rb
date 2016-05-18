class UserDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view ,:user_path

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= %w(user_profiles.first_name users.email )
  end

  def searchable_columns
    @searchable_columns ||= %w(user_profiles.first_name users.email )
  end

  private

    def data
      records.map do |record|
        [
          record.user_profile.first_name,
          link_to(record.email,user_path(record)),
          record.user_profile.phone_number,
          record.user_profile.email
        ]
      end
    end

    def get_raw_records
      User.joins(:user_profile).where(role: 'customer')
    end
end