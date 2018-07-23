class Bankcard < ApplicationRecord
  belongs_to :bankcode
  belongs_to :artisanuser
end
