class Access < ActiveRecord::Base

  # Validators
  validates :identifier, uniqueness: true
end
