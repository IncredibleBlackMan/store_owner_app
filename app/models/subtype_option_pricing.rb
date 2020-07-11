class SubtypeOptionPricing < ApplicationRecord
  belongs_to :product
  validates_presence_of :price
  validates_presence_of :quantity
  validates_presence_of :subtype_options
end
