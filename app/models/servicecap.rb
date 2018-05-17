class Servicecap < ApplicationRecord
  has_and_belongs_to_many :artisanusers, dependent: :destroy
end
