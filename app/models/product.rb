class Product < ApplicationRecord
  belongs_to :user
  has_many :subtypes, dependent: :destroy

  validates_presence_of :name
end
