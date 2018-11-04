class AddAttachmentArtisanuserqrcodeimgToArtisanusers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :artisanusers do |t|
      t.attachment :artisanuserqrcodeimg
    end
  end

  def self.down
    remove_attachment :artisanusers, :artisanuserqrcodeimg
  end
end
