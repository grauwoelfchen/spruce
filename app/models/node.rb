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

  def self.cached_root
    with_scoped_to do |scoped_id|
      Rails.cache.fetch([name, scoped_id, "root"], expires_in: 10.minutes) do
        root_node = includes(:notes).root
        unless root_node
          raise ActiveRecord::RecordNotFound
        end
        root_node
      end
    end
  end

  def self.cached_find(id)
    with_scoped_to do |scoped_id|
      Rails.cache.fetch([name, scoped_id, id], expires_in: 10.minutes) do
        where(:id => id).take!
      end
    end
  end

  def paths
    self_and_ancestors
      .reorder("node_hierarchies.generations DESC")
  end

  private

    def flush_cache
      Rails.cache.delete([self.class.name, user_id, "root"])
      Rails.cache.delete([self.class.name, user_id, id])
    end
end
