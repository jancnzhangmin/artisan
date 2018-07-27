class CreateProfits < ActiveRecord::Migration[5.1]
  def change
    create_table :profits do |t|
      t.string :ordernumber
      t.float :amount
      t.string :summary

      t.timestamps
    end
  end
end
