class Note < ActiveRecord::Base
  include Assignable
  include Visible

  belongs_to :user
  belongs_to :node

  validates_presence_of :name, :if => ->(n) { n.content.present? }
  validates_presence_of :user_id, :node_id, :content

  def name
    content && content.split(/\r?\n/).first
  end
end
