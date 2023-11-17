# frozen_string_literal: true

class Service < ApplicationRecord
  enum deployment_strategy: {
    helm: 'helm'
  }

  belongs_to :user
  belongs_to :vcs_connection
end
