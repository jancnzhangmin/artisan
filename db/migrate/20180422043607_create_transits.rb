class CreateTransits < ActiveRecord::Migration[5.1]
  def change
    create_table :transits do |t|
      t.integer :bartask_id
      t.string :start
      t.string :end
      t.text :summary

      t.timestamps
    end
  end
end
