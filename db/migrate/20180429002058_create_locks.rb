class CreateLocks < ActiveRecord::Migration[5.1]
  def change
    create_table :locks do |t|
      t.string :lock

      t.timestamps
    end
  end
end
