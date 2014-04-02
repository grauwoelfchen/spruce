class Node < ActiveRecord::Base
  include Assignable
  include Visible
  include ChangeRecordable

  belongs_to :user
  has_many   :notes, :dependent => :delete_all
  has_many   :recorded_changes,
    lambda { order(:created_at => :asc) },
    :class_name => "Version::Ring",
    :as         => :item

  acts_as_tree \
    :dependent   => :delete_all,
    :name_column => :name,
    :order       => :name
  has_paper_trail \
    :class_name => "Version::Cycle",
    :versions   => :versions,
    :meta       => { :user_id => :user_id }

  after_update :record_version, :on => :update

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

  private

  def record_version
    original_only = self.paper_trail_options[:only]
    self.paper_trail_options[:only] = %w[name]
    result = store_changes
    self.paper_trail_options[:only] = original_only
    result
  end
end
