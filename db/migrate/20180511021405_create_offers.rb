class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.integer :artisanuser_id
      t.integer :bartask_id
      t.float :price
      t.text :summary
      t.integer :isselect

      t.timestamps
    end
  end
end
