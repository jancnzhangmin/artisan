class AddOrdernumberToUserpayorder < ActiveRecord::Migration[5.1]
  def change
    add_column :userpayorders, :ordernumber, :string
  end
end
