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

  before_validation :apply_operations

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

  def name
    content.to_s.split(/\r?\n/).first.to_s.gsub(/^\*?\s*/, "")
  end

  private

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

    def content_must_not_contain_blank_line
      lines = \
        content.each_line.map.with_index(1) { |line, i|
          i if line.gsub(/\r?\n/, "").empty?
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
      lines = \
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
      lines = \
        content.each_line.map.with_index(1) { |line, i|
          line.gsub(/\r\n|\n/, '') =~ /\A([\s]+)/
          indent = $1.to_s.length
          if (i == 1 && indent != 0) || ![c - 2, c, c + 2].include?(indent)
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
end
