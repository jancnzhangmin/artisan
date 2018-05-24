class Bartaskpro < ApplicationRecord
  belongs_to :bartask
  belongs_to :artisanuser
  has_many :bartaskproimages
end
