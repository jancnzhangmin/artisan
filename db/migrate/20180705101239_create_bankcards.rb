class CreateBankcards < ActiveRecord::Migration[5.1]
  def change
    create_table :bankcards do |t|
      t.references :bankcode, foreign_key: true
      t.references :artisanuser, foreign_key: true
      t.string :cardnumber
      t.string :name

      t.timestamps
    end
  end
end
