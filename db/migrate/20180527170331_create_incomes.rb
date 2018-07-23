class CreateIncomes < ActiveRecord::Migration[5.1]
  def change
    create_table :incomes do |t|
      t.references :artisanuser, foreign_key: true
      t.float :amount
      t.string :bartaskorder
      t.integer :status

      t.timestamps
    end
  end
end
