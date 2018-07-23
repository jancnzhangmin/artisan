class AddSummaryToUserpayorder < ActiveRecord::Migration[5.1]
  def change
    add_column :userpayorders, :summary, :text
  end
end
