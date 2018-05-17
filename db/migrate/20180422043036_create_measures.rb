class CreateMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :measures do |t|
      t.integer :bartask_id
      t.float :roomintop
      t.float :roomouttop
      t.float :roomwidth
      t.integer :isfloorheat
      t.integer :idding
      t.float :dingleft
      t.float :dingright
      t.float :dingtop
      t.integer :doorset
      t.integer :openinout
      t.integer :openleftright
      t.text :summary

      t.timestamps
    end
  end
end
