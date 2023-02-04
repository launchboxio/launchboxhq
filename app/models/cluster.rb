# frozen_string_literal: true

class Cluster < ApplicationRecord
  include Vault::EncryptedModel
  vault_lazy_decrypt!
  vault_attribute :ca_crt
  vault_attribute :token
  vault_attribute :agent_token

  has_many :projects
  has_many :agents
  has_many :cluster_addons, through: :cluster_addon_subscriptions

  belongs_to :user, optional: true
  before_create :generate_slug, :generate_agent_token

  private

  def generate_slug
    self.slug = Haiku.call(variant: -> { SecureRandom.alphanumeric(5).downcase })
  end

  def generate_agent_token
    self.agent_token = SecureRandom.hex(32)
  end
end
