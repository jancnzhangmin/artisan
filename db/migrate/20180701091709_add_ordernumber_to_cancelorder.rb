class AddOrdernumberToCancelorder < ActiveRecord::Migration[5.1]
  def change
    add_column :cancelorders, :ordernumber, :string
  end
end
