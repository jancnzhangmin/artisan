class CreateArtisanextracts < ActiveRecord::Migration[5.1]
  def change
    create_table :artisanextracts do |t|
      t.references :artisanuser, foreign_key: true
      t.string :ordernumber
      t.float :amount

      t.timestamps
    end
  end
end
