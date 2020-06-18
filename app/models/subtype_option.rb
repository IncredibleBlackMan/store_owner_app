class SubtypeOption < ApplicationRecord
  belongs_to :subtype

  validates_presence_of :name
end
