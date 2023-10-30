# frozen_string_literal: true

Doorkeeper::OpenidConnect.configure do
  issuer do |_request|
    ENV['OIDC_DOMAIN'] || 'http://localhost:3000'
  end

  if ENV['OIDC_SIGNING_KEY_FILE'].present?
    signing_key File.read(ENV['OIDC_SIGNING_KEY_FILE'])
  elsif ENV['OIDC_SIGNING_KEY'].present?
    signing_key ENV['OIDC_SIGNING_KEY']
  else
    signing_key nil
  end

  subject_types_supported [:public]

  resource_owner_from_access_token do |access_token|
    # Example implementation:
    User.find_by(id: access_token.resource_owner_id)
  end

  auth_time_from_resource_owner(&:current_sign_in_at)

  reauthenticate_resource_owner do |resource_owner, _return_to|
    # Example implementation:
    # store_location_for resource_owner, return_to
    sign_out resource_owner
    redirect_to new_user_session_url
  end

  # Depending on your configuration, a DoubleRenderError could be raised
  # if render/redirect_to is called at some point before this callback is executed.
  # To avoid the DoubleRenderError, you could add these two lines at the beginning
  #  of this callback: (Reference: https://github.com/rails/rails/issues/25106)
  #   self.response_body = nil
  #   @_response_body = nil
  select_account_for_resource_owner do |resource_owner, return_to|
    # Example implementation:
    # store_location_for resource_owner, return_to
    # redirect_to account_select_url
  end

  subject do |resource_owner, _application|
    # Example implementation:
    resource_owner.id

    # or if you need pairwise subject identifier, implement like below:
    # Digest::SHA256.hexdigest("#{resource_owner.id}#{URI.parse(application.redirect_uri).host}#{'your_secret_salt'}")
  end

  # Protocol to use when generating URIs for the discovery endpoint,
  # for example if you also use HTTPS in development
  # protocol do
  #   :https
  # end

  # Expiration time on or after which the ID Token MUST NOT be accepted for processing. (default 120 seconds).
  # expiration 600

  # Example claims:
  claims do
    # claim :email, response: [:id_token, :user_info], &:email

    # rubocop:disable Style/SymbolProc
    claim :preferred_username do |resource_owner, _scopes, _access_token|
      resource_owner.email
    end

    claim :email, response: %i[id_token user_info] do |resource_owner|
      resource_owner.email
    end
    # rubocop:enable Style/SymbolProc
  end
end
