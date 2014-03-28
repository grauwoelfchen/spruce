class Node < ActiveRecord::Base
  include Assignable
  include Visible

  acts_as_tree \
    :dependent   => :delete_all,
    :name_column => :name,
    :order       => :name
  belongs_to :user
  has_many :notes, :dependent => :delete_all
  has_paper_trail :meta => { :user_id => :user_id }

  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => [:user_id, :parent_id]}
  validates :name,
    :length => {:maximum => 32},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {:with => /\A^[^\.]/, :message => "can't start with ."},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {:with => /\A[^%~\/\\*`]+\z/, :message => "can't contain %~/\\*`"},
    :if     => ->(n) { n.name.present? }
  validates :user_id, :parent_id, :presence => true

  def paths
    self_and_ancestors
      .reorder("node_hierarchies.generations DESC")
  end
end
