class CreateWidthdraws < ActiveRecord::Migration[5.1]
  def change
    create_table :widthdraws do |t|
      t.references :artisanuser, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
