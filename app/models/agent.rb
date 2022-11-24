# frozen_string_literal: true

class Agent < ApplicationRecord
  include Vault::EncryptedModel
  vault_lazy_decrypt!
  vault_attribute :access_token
  vault_attribute :refresh_token

  belongs_to :cluster
end
