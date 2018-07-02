class Cancelorder < ApplicationRecord
  belongs_to :user,optional: true
  belongs_to :artisanuser,optional: true
end
