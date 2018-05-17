class CreateOpenlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :openlocks do |t|
      t.integer :bartask_id
      t.text :summary

      t.timestamps
    end
  end
end
