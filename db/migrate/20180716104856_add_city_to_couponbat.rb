class AddCityToCouponbat < ActiveRecord::Migration[5.1]
  def change
    add_column :couponbats, :city, :string
  end
end
