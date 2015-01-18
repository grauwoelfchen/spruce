class Node < ActiveRecord::Base
  include Assignable
  include Visible
  include ChangeRecordable

  belongs_to :user
  has_many :notes, :dependent => :delete_all
  has_many :recorded_changes,
    lambda { order(:created_at => :asc) },
    :class_name => "Version::Ring",
    :as         => :item

  has_paper_trail \
    :class_name => "Version::Cycle",
    :versions   => :versions,
    :meta       => {:user_id => :user_id}
  acts_as_tree \
    :dependent   => :delete_all,
    :name_column => :name,
    :order       => :name

  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => [:user_id, :parent_id]}
  validates :name, :exclusion => {
    :in      => %w[root],
    :message => "%{value} is reserved"
  }
  validates :name,
    :length => {:maximum => 32},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {:with => /\A^[^\.]/, :message => "can't start with ."},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {
      :with    => /\A[^%~\/\\*`]+\z/,
      :message => "can't contain %~/\\*`"
    },
    :if => ->(n) { n.name.present? }
  validates :user_id, :parent_id, :presence => true

  after_commit :flush_cache

  def paths
    self_and_ancestors
      .reorder("node_hierarchies.generations DESC")
  end

  def self.cached_find(user, id)
    Rails.cache.fetch([name, user.id, id], expires_in: 10.minutes) do
      n = Node.visible_to(user).where(:id => id).first
      raise ActiveRecord::RecordNotFound unless n
      n
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, user_id, id])
  end
end
