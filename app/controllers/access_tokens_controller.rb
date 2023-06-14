class AccessTokensController < AuthenticatedController

  def create
    @token = Doorkeeper::AccessToken.create(access_token_params)
    @token.resource_owner_id = current_user.id
    if @token.save
      render json: @token
    else
      render json: { error: @token.errors }
    end
  end

  def destroy
    token = Doorkeeper::AccessToken.where(id: params[:id], resource_owner_id: current_user.id).first
    if token?
      token.destroy
    else
      head 404
    end
  end

  private

  def access_token_params
    params.require(:access_token).permit(:scopes, :expires_in)
  end
end