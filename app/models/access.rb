require 'bcrypt'

class Access < ActiveRecord::Base
  include BCrypt

  # Filters
  before_save :default_values

  # Validators
  validates :identifier,    uniqueness: true,
                            presence: true
  validates :domain,        uniqueness: true,
                            presence: true
  validates :quotas,        presence: true
  # validates :password_hash, presence: true


  def default_values
    self.size   ||= 0
    self.quotas ||= 0
  end

  def ratio_use
    return 0 if self.size.blank?
    return 0 if self.quotas.blank?

    self.size / self.quotas
  end

  def password
    return if password_hash.blank?

    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    Rails.logger.debug "#{new_password}"
    return if new_password.blank?

    @password          = Password.create(new_password)
    self.password_hash = @password
  end
end
