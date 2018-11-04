class CreateUserextracts < ActiveRecord::Migration[5.1]
  def change
    create_table :userextracts do |t|
      t.references :user, foreign_key: true
      t.string :ordernumber
      t.float :amount

      t.timestamps
    end
  end
end
