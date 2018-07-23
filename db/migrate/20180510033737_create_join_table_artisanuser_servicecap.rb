class CreateJoinTableArtisanuserServicecap < ActiveRecord::Migration[5.1]
  def change
    create_join_table :artisanusers, :servicecaps do |t|
      # t.index [:artisanuser_id, :servicecap_id]
      # t.index [:servicecap_id, :artisanuser_id]
    end
  end
end
