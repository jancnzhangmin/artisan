class AddFingermodeldefToFinger < ActiveRecord::Migration[5.1]
  def change
    add_reference :fingers, :fingermodeldef, foreign_key: true
  end
end
