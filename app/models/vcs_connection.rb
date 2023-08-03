class VcsConnection < ApplicationRecord
  include Vault::EncryptedModel
  belongs_to :user

  vault_lazy_decrypt!
  vault_attribute :access_token
  vault_attribute :refresh_token

end

