class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.references :couponbat, foreign_key: true
      t.bigint :user_id
      t.bigint :artisanuser_id
      t.integer :model
      t.float :facevalue
      t.float :condition
      t.integer :expirytype
      t.datetime :assignexpiry
      t.integer :fixedexpiry
      t.string :ordernumber
      t.integer :alreadyused
      t.string :name
      t.string :couponnumber
      t.text :summary
      t.integer :status
      t.integer :coupontype

      t.timestamps
    end
  end
end
