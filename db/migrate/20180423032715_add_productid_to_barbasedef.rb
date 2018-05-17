class AddProductidToBarbasedef < ActiveRecord::Migration[5.1]
  def change
    add_column :barbasedefs, :product_id, :integer
  end
end
