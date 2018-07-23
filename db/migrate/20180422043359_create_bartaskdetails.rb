class CreateBartaskdetails < ActiveRecord::Migration[5.1]
  def change
    create_table :bartaskdetails do |t|
      t.integer :bartask_id
      t.string :product
      t.string :productdetail
      t.string :productattch
      t.integer :number
      t.integer :floor
      t.text :summary

      t.timestamps
    end
  end
end
