class CreateBartasks < ActiveRecord::Migration[5.1]
  def change
    create_table :bartasks do |t|
      t.integer :user_id
      t.float :preprice
      t.string :province
      t.string :city
      t.string :district
      t.string :address
      t.integer :status
      t.datetime :installtime
      t.string :ordernumber

      t.timestamps
    end
  end
end
