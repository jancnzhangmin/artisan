class CreateServicecoms < ActiveRecord::Migration[5.1]
  def change
    create_table :servicecoms do |t|
      t.float :base
      t.float :percent

      t.timestamps
    end
  end
end
