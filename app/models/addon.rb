# frozen_string_literal: true

class Addon < ApplicationRecord
  include Vault::EncryptedModel
  vault_lazy_decrypt!
  vault_attribute :username
  vault_attribute :password
end
