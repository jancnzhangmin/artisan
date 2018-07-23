class AddBartaskproidToBartaskproimage < ActiveRecord::Migration[5.1]
  def change
    add_reference :bartaskproimages, :bartaskpro, foreign_key: true
  end
end
