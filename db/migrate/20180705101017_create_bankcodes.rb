class CreateBankcodes < ActiveRecord::Migration[5.1]
  def change
    create_table :bankcodes do |t|
      t.string :bankcode
      t.string :bank

      t.timestamps
    end
  end
end
