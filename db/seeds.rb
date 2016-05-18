# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.new({email: "admin@gmail.com",
				          password: "mindfire", 
				          password_confirmation: "mindfire",
				          role: "admin",
				          confirmed_at: Time.zone.now
                })
u1.save(validate: false)

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'brands.csv'))
csv = CSV.parse(csv_text, headers: false)
csv.each do |row|
  t = Brand.new
  t.brand_name = row[0]
  t.is_approved = true
  t.is_active = true
  t.save
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'categories.csv'))
csv = CSV.parse(csv_text, headers: false)
csv.each do |row|
  t = Category.new
  t.category_name = row[0]
  t.save
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'products.csv'))
csv = CSV.parse(csv_text, headers: false)
csv.each do |row|
  t = Product.new
  t.product_name = row[0]
  t.product_description = row[1]
  t.unit_type = row[2].strip
  t.category_id = row[3]
  t.brand_id = row[4]
  t.is_active = true
  if File.exist?(File.join(Rails.root, "/lib/seeds/images/#{row[5]}.jpg"))
    t.image = File.open(File.join(Rails.root, "/lib/seeds/images/#{row[5]}.jpg")).read
  else
    t.image = nil
  end
  t.save
end


