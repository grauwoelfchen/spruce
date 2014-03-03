class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :username, :email, :presence => true
  validates :username,
    :length => {:minimum => 3, :maximum => 18},
    :if     => ->(u) { u.username.present? && u.errors[:username].empty? }
  validates :username,
    :format => {:with => /\A[a-z0-9\_]+\z/, :message => "must be alphanumeric characters and _"},
    :if     => ->(u) { u.username.present? }
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

  has_many :notes

  def active?
    activation_state == "active"
  end

  def valid_attribute?(attr, message_keys = [])
    self.valid?
    messages = message_keys.map { |m| I18n.t("errors.messages.#{m}") }
    self.errors.messages.delete_if { |key, values|
      key != attr || values.reject { |v| v.in?(messages) }.present?
    }
    self.errors[attr].blank?
  end
end
