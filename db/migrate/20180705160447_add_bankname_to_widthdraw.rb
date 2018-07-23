class AddBanknameToWidthdraw < ActiveRecord::Migration[5.1]
  def change
    add_column :widthdraws, :bankname, :string
    add_column :widthdraws, :cardnumber, :string
    add_column :widthdraws, :bank, :string
    add_column :widthdraws, :withdrawto, :integer
    add_column :widthdraws, :processstatus, :integer
    add_column :widthdraws, :tradeno, :string
    add_column :widthdraws, :summary, :string
  end
end
