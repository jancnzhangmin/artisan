class AddCityToCoupon < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :city, :string
  end
end
