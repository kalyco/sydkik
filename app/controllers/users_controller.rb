class UsersController < ApplicationController
	before_action :authenticate_user!

  private

  def set_user
    @user = User.find_by_id(params[:id]) || current_user
  end

  def user_params
    params.require(:user).permit(:id, :name, :email, :phone, :zip, :zip_radius, :type, :password)
  end
end