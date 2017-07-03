namespace :products do

  desc "importing new products"
  task initialize: :environment do
    CSV.foreach(Rails.root.to_s + "/config/data/products.csv") do |row|
      next if row[0] == "SKU (Unique ID)"
       product = Product.create(sku: row[0], name: row[1], price: row[2], description: row[3])
       puts "Created product #{product.name}."
    end
    puts "Products initialized."
  end

  desc "reseting all products"
  task reset: :environment do
    Product.destroy_all
    CSV.foreach(Rails.root.to_s + "/config/data/products.csv") do |row|
      next if row[0] == "SKU (Unique ID)"
       product = Product.create(sku: row[0], name: row[1], price: row[2].to_f, description: row[3])
       puts "Created product #{product.name}."
    end
    puts "Products updated."
  end

end
