# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # before_action :load_oidc

  private

  def load_oidc
    @client = Doorkeeper::Application.find_by(name: 'Kubernetes OIDC')
    ENV.fetch('OIDC_DOMAIN', 'http://localhost:3000')
  end
end
