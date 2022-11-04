class AddonSubscription < ApplicationRecord
  belongs_to :space
  belongs_to :addon
end
