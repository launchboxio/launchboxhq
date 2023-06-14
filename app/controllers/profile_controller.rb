class ProfileController < AuthenticatedController
  def index
    # Load all of our profile settings
    @access_tokens = Doorkeeper::AccessToken.where(resource_owner_id: current_user.id)
  end
end