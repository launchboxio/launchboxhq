class ResourceDeployment < ApplicationRecord
  belongs_to :project
  belongs_to :resource

end
