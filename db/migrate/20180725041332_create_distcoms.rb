class CreateDistcoms < ActiveRecord::Migration[5.1]
  def change
    create_table :distcoms do |t|
      t.float :distcom

      t.timestamps
    end
  end
end
