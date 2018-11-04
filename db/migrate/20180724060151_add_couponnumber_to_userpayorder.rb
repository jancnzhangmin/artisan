class AddCouponnumberToUserpayorder < ActiveRecord::Migration[5.1]
  def change
    add_column :userpayorders, :couponnumber, :string
  end
end
