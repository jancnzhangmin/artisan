class Artisanuser < ApplicationRecord
  has_and_belongs_to_many :servicecaps
  has_many :offers
  has_many :bartaskpros
  has_many :incomes
  has_many :widthdraws
  has_many :withdrawpwds
  has_many :bankcards
  belongs_to :user, optional: true
  has_and_belongs_to_many :users
  has_many :artisanextracts
  has_many :childrens, class_name: "Artisanuser", foreign_key: "up_id"
  belongs_to :parent, class_name: "Artisanuser", foreign_key: "up_id", optional: true
  has_attached_file :idfront, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :idfront
  has_attached_file :idback, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :idback
  has_attached_file :artisanuserqrcodeimg, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :artisanuserqrcodeimg


end
