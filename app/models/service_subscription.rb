# frozen_string_literal: true

class ServiceSubscription < ApplicationRecord
  belongs_to :project
  belongs_to :service
end
