# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :find_user, only: %i[show update]
    def index
      @users = User.all
    end

    def show; end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.password = Devise.friendly_token.first(15)
      if @user.save
        flash[:notice] = 'User created'
        redirect_to admin_user_path(@user)
      else
        flash[:notice] = @user.errors.full_messages
        redirect_to new_admin_user_path
      end
    end

    def update
      flash[:notice] = if @user.update(update_params)
                         'User updated'
                       else
                         @user.errors.full_messages
                       end
      redirect_to admin_user_path(@user)
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email)
    end

    def update_params
      params.require(:user).permit(:activated, :confirmed_at)
    end
  end
end
