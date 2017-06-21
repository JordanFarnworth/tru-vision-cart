namespace :products do
  require 'roo'

  desc "importing new products"
  task initialize: :environment do
    path = Rails.root.to_s + "/config/data/products.xlsx"
    xlsx = Roo::Spreadsheet.open(path)
    [*5..10].each {|i| info = xlsx.row(i); Product.create(sku: info[0], name: info[1], price: info[2], description: info[3]) }
  end

  desc "TODO"
  task reset: :environment do
    Product.destroy_all
    path = Rails.root.to_s + "/config/data/products.xlsx"
    xlsx = Roo::Spreadsheet.open(path)
    [*5..10].each {|i| info = xlsx.row(i); Product.create(sku: info[0], name: info[1], price: info[2], description: info[3]) }
  end

end
