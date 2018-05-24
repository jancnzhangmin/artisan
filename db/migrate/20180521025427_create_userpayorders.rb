class CreateUserpayorders < ActiveRecord::Migration[5.1]
  def change
    create_table :userpayorders do |t|
      t.integer :artisanuser_id
      t.integer :user_id
      t.integer :bartask_id
      t.float :price
      t.integer :status

      t.timestamps
    end
  end
end
