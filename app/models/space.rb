# frozen_string_literal: true

class Space < ApplicationRecord
  include Vault::EncryptedModel
  belongs_to :cluster
  belongs_to :user

  has_many :addon_subscriptions
  has_many :addons, through: :addon_subscriptions

  has_and_belongs_to_many :users
  before_create :generate_slug

  vault_lazy_decrypt!
  vault_attribute :ca_crt
  vault_attribute :token

  private

  def generate_slug
    self.slug = Haiku.call(variant: -> { SecureRandom.alphanumeric(5).downcase })
  end
end
