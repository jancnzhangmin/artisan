class CreateBartaskpros < ActiveRecord::Migration[5.1]
  def change
    create_table :bartaskpros do |t|
      t.integer :bartask_id
      t.integer :artisanuser_id
      t.datetime :begintime
      t.datetime :endtime
      t.text :summary

      t.timestamps
    end
  end
end
