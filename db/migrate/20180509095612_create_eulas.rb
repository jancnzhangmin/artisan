class CreateEulas < ActiveRecord::Migration[5.1]
  def change
    create_table :eulas do |t|
      t.string :tile
      t.text :eula

      t.timestamps
    end
  end
end
