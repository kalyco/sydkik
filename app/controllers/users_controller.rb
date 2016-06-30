class UsersController < ApplicationController
	before_action :authenticate_user!


  def deeplink
    Rails.logger.debug(params[:signature])
    @user = User.read_access_token(params[:signature])
    Rails.logger.debug(@user)
    if @user
      sign_in @user
      redirect_to user_path(@user)
    else
      # :nocov:
      render text: "#{params} Invalid Parameter", status: :bad_status
      # :nocov:
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id]) || current_user
  end

  def user_params
    params.require(:user).permit(:id, :name, :email, :phone, :zip, :zip_radius, :type, :password)
  end
end