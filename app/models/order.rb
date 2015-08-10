class Order < ActiveRecord::Base
  belongs_to :purchaser
  has_many :items, through: :order_items
  has_many :order_items
end
