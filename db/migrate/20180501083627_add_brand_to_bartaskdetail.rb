class AddBrandToBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    add_column :bartaskdetails, :brand, :string
  end
end
