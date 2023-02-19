# frozen_string_literal: true

class AddonSubscription < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :cluster, optional: true

  belongs_to :addon
end
