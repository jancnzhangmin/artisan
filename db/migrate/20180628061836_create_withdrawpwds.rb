class CreateWithdrawpwds < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawpwds do |t|
      t.references :artisanuser, foreign_key: true
      t.string :password_digest

      t.timestamps
    end
  end
end
