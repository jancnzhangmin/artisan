class Bartaskdetail < ApplicationRecord
  belongs_to :bartask
  has_and_belongs_to_many :barincrementdefs
  has_and_belongs_to_many :barbasedefs
  belongs_to :lock
  belongs_to :product
end
