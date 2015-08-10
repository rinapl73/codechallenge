require 'csv'
class Importer
  
  # Expects the following csv header items
  # "purchaser_name", "item_description", item_price", 
  # "purchase_count", "merchant_address" "merchant_name"
  def self.import(file)
    importer = self.new
    importer.perform_import file
  end

  def perform_import(file)
    CSV.foreach(file.path, headers: true) do |row|
      row = row.to_hash.symbolize_keys
      item = create_item row[:item_description], row[:item_price]
      create_purchaser row[:purchaser_name]
      create_address row[:merchant_address]
      create_merchant row[:merchant_name]
      create_order
      create_order_item row[:purchase_count]
    end
    calculate_revenue
  end
  
  private
  
  def create_item(name, price)
    @item = Item.where(name: name, price: price).first_or_create!
  end

  def create_purchaser(name)
    @purchaser = Purchaser.where(name: name).first_or_create!
  end

  def create_address(name)
    @address = Address.where(name: name).first_or_create!
  end

  def create_merchant(name)
    @merchant = Merchant.where(name: name).first_or_create!(address_id: @address.id)
  end

  def create_order
    @order = Order.create!(purchaser_id: @purchaser.id)
  end

  def create_order_item(p_count)
    OrderItem.create!(
      order_id: @order.id,
      item_id: @item.id,
      quantity: p_count,
      merchant_id: @merchant.id
    )
  end
  
  def calculate_revenue
    total = 0
    OrderItem.includes(:item).each do |oi|
      total += (oi.quantity * oi.item.price)
    end
    total
  end

end