class Product < ApplicationRecord
  belongs_to :user
  has_many :subtypes, dependent: :destroy
  has_many :subtype_option_pricings, dependent: :destroy

  validates_presence_of :name
end
