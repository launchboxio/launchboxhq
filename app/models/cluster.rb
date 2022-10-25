class Cluster < ApplicationRecord
  belongs_to :user, optional: true
end
