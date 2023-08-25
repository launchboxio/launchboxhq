class ResourceAddonMapping < ApplicationRecord
  belongs_to :addon_subscription
  belongs_to :resource_deployment
end
