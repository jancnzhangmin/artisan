class AddStatusToOffer < ActiveRecord::Migration[5.1]
  def change
    add_column :offers, :status, :integer
  end
end
