class CreateServicecaps < ActiveRecord::Migration[5.1]
  def change
    create_table :servicecaps do |t|
      t.string :servicecap

      t.timestamps
    end
  end
end
