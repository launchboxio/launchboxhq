class Cluster < ApplicationRecord
  include Vault::EncryptedModel
  vault_lazy_decrypt!
  vault_attribute :ca_crt
  vault_attribute :token

  belongs_to :user, optional: true

end
