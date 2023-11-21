# frozen_string_literal: true

class Repository < ApplicationRecord
  enum deployment_strategy: {
    helm: 'helm'
  }

  belongs_to :vcs_connection
  has_many :services
  belongs_to :user
end
