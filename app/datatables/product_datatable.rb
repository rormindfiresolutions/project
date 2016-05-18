class ProductDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :product_change_activation_status_path

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= %w(products.product_name)
  end

  def searchable_columns
    @searchable_columns ||= %w(products.product_name)
  end

  private

    def data
      records.map do |record|
        [
          record.product_name + '(' + record.unit_type + ')',
          [ 
            if record.is_active 
              link_to('Deactivate', product_change_activation_status_path(record), method: :put,
              class: "btn btn-primary") 
            else
              link_to('Activate', product_change_activation_status_path(record), method: :put, 
              class: "btn btn-primary light-green")
            end
          ]
        ]
      end
    end

    def get_raw_records
      Product.all
    end
end