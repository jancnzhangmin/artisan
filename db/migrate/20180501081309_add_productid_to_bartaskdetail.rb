class AddProductidToBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    add_column :bartaskdetails, :product_id, :integer
  end
end
