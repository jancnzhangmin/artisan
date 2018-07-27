class AddProjectdefToBartaskdetail < ActiveRecord::Migration[5.1]
  def change
    add_reference :bartaskdetails, :projectdef, foreign_key: true
  end
end
