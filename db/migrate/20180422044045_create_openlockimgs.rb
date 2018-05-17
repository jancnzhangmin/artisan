class CreateOpenlockimgs < ActiveRecord::Migration[5.1]
  def change
    create_table :openlockimgs do |t|
      t.integer :openlock_id

      t.timestamps
    end
  end
end
