class AddLockToBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    add_column :bartaskdetails, :lock_id, :integer
  end
end
