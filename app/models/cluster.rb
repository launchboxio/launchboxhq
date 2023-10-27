# frozen_string_literal: true

class Cluster < ApplicationRecord
  include Vault::EncryptedModel
  vault_lazy_decrypt!
  vault_attribute :ca_crt
  vault_attribute :token

  has_many :projects
  has_many :agents
  has_many :cluster_addons, through: :cluster_addon_subscriptions

  belongs_to :user, optional: true
  before_create :generate_slug
  belongs_to :oauth_application, class_name: 'Doorkeeper::Application'

  # rubocop:disable Metrics/MethodLength
  def get_client(path, api_version)
    if ca_crt.blank? || token.blank?
      auth_options = {
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token'
      }
      ssl_options = {}
      ssl_options[:ca_file] = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt' if File.exist?('/var/run/secrets/kubernetes.io/serviceaccount/ca.crt')
      Kubeclient::Client.new(
        "https://kubernetes.default.svc#{path}",
        api_version,
        auth_options:,
        ssl_options:
      )
    else
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(ca_crt))
      @options = {
        auth_options: { bearer_token: token },
        ssl_options: {
          cert_store:,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER
        }
      }
      Kubeclient::Client.new("#{host}/#{path}", api_version, **@options)
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def generate_slug
    self.slug = Haiku.call(variant: -> { SecureRandom.alphanumeric(5).downcase })
  end
end
