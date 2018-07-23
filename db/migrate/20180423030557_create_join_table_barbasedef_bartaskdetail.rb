class CreateJoinTableBarbasedefBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    create_join_table :barbasedefs, :bartaskdetails do |t|
      # t.index [:barbasedef_id, :bartaskdetail_id]
      # t.index [:bartaskdetail_id, :barbasedef_id]
    end
  end
end
