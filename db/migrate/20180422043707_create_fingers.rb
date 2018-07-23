class CreateFingers < ActiveRecord::Migration[5.1]
  def change
    create_table :fingers do |t|
      t.integer :bartask_id
      t.string :model
      t.text :summary

      t.timestamps
    end
  end
end
