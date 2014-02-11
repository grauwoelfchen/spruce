class Node < ActiveRecord::Base
  include Assignable
  include Visible

  acts_as_tree \
    :dependent   => :delete_all,
    :name_column => :name,
    :order       => :name

  belongs_to :user

  validates :name, :user_id, :presence => true
  validates :name, :uniqueness => { :scope => [:user_id, :parent_id] }
end
