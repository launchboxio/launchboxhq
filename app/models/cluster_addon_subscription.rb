# frozen_string_literal: true

class ClusterAddonSubscription < ApplicationRecord
  belongs_to :cluster
  belongs_to :cluster_addon
end
