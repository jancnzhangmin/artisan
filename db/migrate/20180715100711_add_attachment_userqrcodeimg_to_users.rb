class AddAttachmentUserqrcodeimgToUsers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :users do |t|
      t.attachment :userqrcodeimg
    end
  end

  def self.down
    remove_attachment :users, :userqrcodeimg
  end
end
