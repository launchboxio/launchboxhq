module Admin
  class AdminController < ApplicationController
    before_action :authenticate_admin!

    private
    def authenticate_admin!
      redirect_to new_user_session_path unless user_signed_in?
      authenticate_user!
      redirect_to :projects, status: :forbidden unless current_user.admin?
    end
  end
end