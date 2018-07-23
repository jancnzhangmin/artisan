class User < ApplicationRecord
  has_many :bartasks
  has_and_belongs_to_many :artisanusers
  has_many :childrens, class_name: "User", foreign_key: "up_id"
  belongs_to :parent, class_name: "User", foreign_key: "up_id", optional: true
  has_attached_file :userqrcodeimg, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :userqrcodeimg
end
