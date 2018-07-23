class AddContactToBartask < ActiveRecord::Migration[5.1]
  def change
    add_column :bartasks, :contact, :string
    add_column :bartasks, :contactphone, :string
    add_column :bartasks, :summary, :text
  end
end
