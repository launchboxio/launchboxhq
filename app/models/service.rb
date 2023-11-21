# frozen_string_literal: true

class Service < ApplicationRecord
  enum deployment_strategy: {
    helm: 'helm'
  }

  belongs_to :repository
end
