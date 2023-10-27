# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      @auth = request.env['omniauth.auth']
      handle
    end

    def gitlab
      @auth = request.env['omniauth.auth']
      handle
    end

    def bitbucket
      @auth = request.env['omniauth.auth']
      handle
    end

    def failure
      redirect_to root_path
    end

    private

    def handle
      if user_signed_in?
        # The user is already signed in. Attach the VCS connection,
        # and redirect back to settings
        @user = current_user
        store_vcs_connection
        set_flash_message(:notice, :success, kind: @auth.provider) if is_navigational_format?
        redirect_to settings_path and return
      end
      # First, we check if a user already exists with the current
      @user = User.find_by(email: @auth.info.email)
      if @user
        # If the provider matches, we log them in, and ensure
        # the VCS connection is stored
        if @user.provider == @auth.provider && @user.uid == @auth.uid
          store_vcs_connection
          set_flash_message(:notice, :success, kind: @auth.provider) if is_navigational_format?
          sign_in_and_redirect projects_path, event: :authentication
        else
          # The user exists, but with a different provider. For example, they registered with
          # email, and then tried to login with Github. We only want to support this
          # for adding providers to an existing account (handled above). So here, we just flash an
          # error message and request login again
          redirect_to new_user_session_path, notice: 'This email is registered with a different provider' and return
        end
      else

        # Lastly, we have someone logging in with Github, no pre-existing email matched to it
        # Create an account, attach the VCS connection, and route to the home page
        @user = User.create(email: @auth.info.email) do |user|
          user.password = Devise.friendly_token[0, 20]
          user.provider = @auth.provider
          user.uid = @auth.uid
        end

        if @user.persisted?
          store_vcs_connection
          set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
          sign_in_and_redirect projects_path, event: :authentication # this will throw if @user is not activated
        else
          session['devise.facebook_data'] = @auth.except(:extra) # Removing extra as it can overflow some session stores
          redirect_to new_user_registration_url
        end
      end
    end

    def store_vcs_connection
      @connection = @user.vcs_connections.find_or_create_by(provider: @auth.provider, uid: @auth.uid)
      @connection.access_token = @auth.credentials.token
      @connection.refresh_token = @auth.credentials.refresh_token
      @connection.expiry = @auth.credentials.expiry
      @connection.email = @auth.info.email
      @connection.save!
    end
  end
end
