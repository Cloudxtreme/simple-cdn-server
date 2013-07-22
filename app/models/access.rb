class Access < ActiveRecord::Base

  # Validators
  validates :identifier,    uniqueness: true,
                            presence: true
  validates :domain,        uniqueness: true,
                            presence: true
  validates :quotas,        presence: true

end
