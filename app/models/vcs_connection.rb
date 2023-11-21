# frozen_string_literal: true

class VcsConnection < ApplicationRecord
  include Vault::EncryptedModel
  belongs_to :user

  vault_lazy_decrypt!
  vault_attribute :access_token
  vault_attribute :refresh_token

  def as_json(options = {})
    options[:except] ||= %i[access_token_encrypted refresh_token_encrypted access_token refresh_token]
    super(options)
  end
end
