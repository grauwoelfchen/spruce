class Note < ActiveRecord::Base
  validates_presence_of :content

  def name
    content && content.split(/\r?\n/).first
  end
end
