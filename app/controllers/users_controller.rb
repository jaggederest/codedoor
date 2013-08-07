class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
    @user = current_user.programmer
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'Your profile has been updated.'
      redirect_to user_path(params[:id])
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_id, :title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire)
  end

end
