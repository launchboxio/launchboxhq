class ApplicationController < ActionController::Base
  before_action :load_oidc

  private
  def load_oidc
    @client = Doorkeeper::Application.find_by(name: "Kubernetes OIDC")
    @domain = ENV['OIDC_DOMAIN']
  end
end
