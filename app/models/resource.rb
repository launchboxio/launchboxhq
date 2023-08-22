class Resource < ApplicationRecord
  has_and_belongs_to_many :projects
  belongs_to :user
  belongs_to :vcs_connection
end
