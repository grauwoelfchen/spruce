class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :username, :email, :presence => true
  validates :username,
    :length => {:minimum => 3, :maximum => 18},
    :if     => ->(u) { u.username.present? && u.errors[:username].empty? }
  validates :username,
    :format => {
      :with    => /\A[a-z0-9\_]+\z/,
      :message => "must be alphanumeric characters and _"
    },
    :if => ->(u) { u.username.present? }
  validates :username,
    :uniqueness => true,
    :if         => ->(u) { u.username.present? }
  validates :email,
    :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
    :if     => ->(u) { u.email.present? }
  validates :email,
    :length => {:minimum => 6, :maximum => 64},
    :if     => ->(u) { u.email.present? && u.errors[:email].empty? }
  validates :email,
    :uniqueness => true,
    :if         => ->(u) { u.email.present? }
  validates :password,
    :length => {:minimum => 4},
    :if     => ->(u) { u.password.present? }
  validates :password, :confirmation => true, :presence => true
  validates :password_confirmation, :presence => true

  has_many :nodes
  has_many :notes

  def active?
    activation_state == "active"
  end

  # see https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/en.yml
  def valid_attribute?(attr, exclude_keys = [])
    self.valid?
    # TODO improve flexibility of args
    # currently, ignores error message using equality(includeness) of string
    exclude_messages = exclude_keys.map { |m| I18n.t("errors.messages.#{m}") }
    # delete unuse errors for other attrs and unfocesd error messages
    self.errors.messages.reject! { |key, _|
      key != attr
    }.map { |_, values|
      values.reject! { |v| v.in?(exclude_messages) }
    }
    self.errors[attr].blank?
  end
end
