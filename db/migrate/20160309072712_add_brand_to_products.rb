class AddBrandToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :brand, index: true, foreign_key: true
  end
end
