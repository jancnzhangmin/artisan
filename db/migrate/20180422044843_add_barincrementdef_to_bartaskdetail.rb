class AddBarincrementdefToBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    add_column :bartaskdetails, :barincrementdef_id, :integer
    add_column :bartaskdetails, :barbasedef_id, :integer
  end
end
