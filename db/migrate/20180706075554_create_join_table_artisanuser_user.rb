class CreateJoinTableArtisanuserUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :artisanusers, :users do |t|
      # t.index [:artisanuser_id, :user_id]
      # t.index [:user_id, :artisanuser_id]
    end
  end
end
