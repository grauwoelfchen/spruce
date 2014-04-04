class Note < ActiveRecord::Base
  include Assignable
  include Visible
  include ChangeRecordable

  belongs_to :user
  belongs_to :node
  has_many   :recorded_changes,
    lambda { order(:created_at => :asc) },
    :class_name => "Version::Layer",
    :as         => :item

  has_paper_trail \
    :class_name => "Version::Cycle",
    :meta       => { :user_id => :user_id }

  validates :name, :presence => true, :if => ->(n) { n.content.present? }
  validates :name,
    :length => {:maximum => 64},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {:with => /\A^[^.]+\z/, :message => "can't start with ."},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {:with => /\A[^%~\/\\*`]+\z/, :message => "can't contain %~/\\*`"},
    :if     => ->(n) { n.name.present? }
  validates_presence_of :user_id, :node_id, :content

  def name
    content && content.split(/\r?\n/).first
  end
end
