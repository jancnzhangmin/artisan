class CreateJoinTableBarincrementdefBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    create_join_table :barincrementdefs, :bartaskdetails do |t|
      # t.index [:barincrementdef_id, :bartaskdetail_id]
      # t.index [:bartaskdetail_id, :barincrementdef_id]
    end
  end
end
