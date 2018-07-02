class Withdrawpwd < ApplicationRecord
  has_secure_password
  belongs_to :artisanuser
end
