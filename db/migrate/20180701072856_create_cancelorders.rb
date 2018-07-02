class CreateCancelorders < ActiveRecord::Migration[5.1]
  def change
    create_table :cancelorders do |t|
      t.string :cancelparty
      t.references :user, foreign_key: true
      t.references :artisanuser, foreign_key: true
      t.float :amount
      t.float :refunduseramount
      t.text :reason
      t.text :opinions
      t.integer :status
      t.float :refundartisanuseramount

      t.timestamps
    end
  end
end
