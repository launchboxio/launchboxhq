# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :authenticate_user!

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

  # def set_organization(organization)
  #   session[:current_organization] = organization
  # end

  def current_organization
    session[:current_organization] || Organization.where(name: current_user.email, type: 'personal').first
  end

  helper_method :current_organization
end
