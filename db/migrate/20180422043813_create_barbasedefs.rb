class CreateBarbasedefs < ActiveRecord::Migration[5.1]
  def change
    create_table :barbasedefs do |t|
      t.integer :bartaskdetail_id
      t.string :name
      t.text :summary

      t.timestamps
    end
  end
end
