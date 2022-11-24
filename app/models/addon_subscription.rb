# frozen_string_literal: true

class AddonSubscription < ApplicationRecord
  belongs_to :space
  belongs_to :addon
end
