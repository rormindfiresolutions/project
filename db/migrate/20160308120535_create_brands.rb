class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
    	t.string :brand_name
    	t.boolean :is_approved
    	t.boolean :is_active

     t.timestamps null: false
    end
  end
end
