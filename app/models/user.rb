# frozen_string_literal: true

class User < ApplicationRecord
  before_save :downcase_email
  has_secure_password

  validates_uniqueness_of :username
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
