# frozen_string_literal: true

class AddonSubscription < ApplicationRecord
  include Vault::EncryptedModel

  belongs_to :project
  belongs_to :addon

  vault_attribute :connection_secret
end
