module Settings
  class AccessTokensController < Settings::SettingsController
    def index
      @tokens = current_user.access_tokens
    end

    def new
      @token = current_user.access_tokens.build
    end

    def create
      @token = current_user.access_tokens.create
      @token.save!
      flash[:notice] = @token.token
      redirect_to tokens_path
    end

    def destroy
      token = Doorkeeper::AccessToken.where(id: params[:id], resource_owner_id: current_user.id).first!
      token.destroy

      flash[:notice] = 'Access Token Deleted'
      redirect_to tokens_path
    end

    private

    def access_token_params
      params.require(:access_token).permit(:scopes, :expires_in)
    end
  end
end