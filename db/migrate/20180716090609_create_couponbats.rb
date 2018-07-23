class CreateCouponbats < ActiveRecord::Migration[5.1]
  def change
    create_table :couponbats do |t|
      t.string :name
      t.integer :number
      t.float :facevalue
      t.float :condition
      t.integer :expirytype
      t.datetime :assignexpiry
      t.integer :fixedexpiry
      t.integer :coupontype
      t.text :summary
      t.integer :generate
      t.string :numbegin
      t.string :numend

      t.timestamps
    end
  end
end
