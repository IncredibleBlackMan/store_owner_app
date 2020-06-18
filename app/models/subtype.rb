class Subtype < ApplicationRecord
  belongs_to :product
  has_many :subtype_options, dependent: :destroy

  validates_presence_of :name
end
