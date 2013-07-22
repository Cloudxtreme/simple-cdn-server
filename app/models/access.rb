class Access < ActiveRecord::Base

  # Filters
  before_save :default_values

  # Validators
  validates :identifier,    uniqueness: true,
                            presence: true
  validates :domain,        uniqueness: true,
                            presence: true
  validates :quotas,        presence: true


  def default_values
    self.size   ||= 0
    self.quotas ||= 0
  end

  def ratio_use
    return 0 if self.size.blank?
    return 0 if self.quotas.blank?

    self.size / self.quotas
  end
end
