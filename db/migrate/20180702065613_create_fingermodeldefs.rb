class CreateFingermodeldefs < ActiveRecord::Migration[5.1]
  def change
    create_table :fingermodeldefs do |t|
      t.string :model

      t.timestamps
    end
  end
end
