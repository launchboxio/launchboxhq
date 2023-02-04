# frozen_string_literal: true

class AddonSubscription < ApplicationRecord
  belongs_to :project
  belongs_to :addon
end
