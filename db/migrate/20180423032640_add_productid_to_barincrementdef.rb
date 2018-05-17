class AddProductidToBarincrementdef < ActiveRecord::Migration[5.1]
  def change
    add_column :barincrementdefs, :product_id, :integer
  end
end
