class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :openid
      t.string :login
      t.string :password_degest
      t.integer :status

      t.timestamps
    end
  end
end
