class User < ApplicationRecord
  has_many :bartasks
  has_and_belongs_to_many :artisanusers
end
