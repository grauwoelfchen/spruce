require "lilac"

class Note < ActiveRecord::Base
  include Assignable
  include Visible
  include ChangeRecordable

  belongs_to :user
  belongs_to :node
  has_many :recorded_changes,
    lambda { order(:created_at => :asc) },
    :class_name => "Version::Layer",
    :as         => :item

  has_paper_trail \
    :class_name => "Version::Cycle",
    :meta       => {:user_id => :user_id}

  validates_presence_of :user_id, :node_id, :content
  validates :name, :presence => true, :if => ->(n) { n.content.present? }
  validates :name,
    :length => {:maximum => 64},
    :if     => ->(n) { n.name.present? }
  validates :name,
    :format => {
      :with    => /\A[^\.\s]/,
      :message => "can't start with dot and whitespace"
    },
    :if => ->(n) { n.name.present? }
  validates :name,
    :format => {
      :with    => /\A[^%~\/\\`]+\z/,
      :message => "can't contain %~/\\*`"
    },
    :if => ->(n) { n.name.present? }
  validates :content,
    :length => {:maximum => 1024 * 9},
    :if     => ->(n) { n.content.present? }
  validate \
    :content_must_not_contain_blank_line,
    :content_must_be_valid_outline_syntax,
    :content_must_be_valid_indent,
    :if => ->(n) { n.content.present? && n.content != n.name }

  before_validation :apply_operations

  before_save :convert_content
  after_commit :flush_cache

  def self.cached_find(id)
    with_scoped_to do |scoped_id|
      Rails.cache.fetch([name, scoped_id, id], expires_in: 10.minutes) do
        where(:id => id).take!
      end
    end
  end

  def name
    content.to_s.split(/\r?\n/).first.to_s.gsub(/^\*?\s*/, '')
  end

  private

    def content_must_not_contain_blank_line
      lines =
        content.each_line.map.with_index(1) { |line, i|
          i unless line.present?
        }.compact
      unless lines.empty?
        feedback = {
          :message => "must not contain blank line",
          :lines   => lines
        }
        errors.add(:content, feedback)
      end
    end

    def content_must_be_valid_outline_syntax
      lines =
        content.each_line.map.with_index(1) { |line, i|
          i if line !~ /\A(\s*\*\s[^\s].*|)(\r?\n)?\z/
        }.compact
      unless lines.empty?
        feedback = {
          :message => "must start with bullet points '* '",
          :lines   => lines
        }
        errors.add(:content, feedback)
      end
    end

    def content_must_be_valid_indent
      c = 0; # current indent
      lines =
        content.each_line.map.with_index(1) { |line, i|
          line.gsub(/\r\n|\n/, '') =~ /\A([\s]+)/
          indent = $1.to_s.length
          if (i == 1 && indent != 0) ||
             indent.odd? ||
             indent > (c + 2)
            i
          else
            c = indent
            nil
          end
        }.compact
      unless lines.empty?
        feedback = {
          :message => "has invalid indent",
          :lines   => lines
        }
        errors.add(:content, feedback)
      end
    end

    def apply_operations
      # TODO improve operation
      if content
        # -
        self.content = content
          .gsub(/^(\s*)\s{2}\-\*/, '\1*')
          .gsub(/\u0001/, "")
        # +
        self.content = content
          .gsub(/^(\s*)\+\*/u, '\1  *')
          .gsub(/\u0001/, "")
      end
    end

    def convert_content
      if "content".in?(changed)
        self.content_html = Lilac::List.new(content).to_html
      end
    end

    def flush_cache
      Rails.cache.delete([self.class.name, user_id, id])
    end
end
