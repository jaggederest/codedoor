class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if current_user.update(user_params)
      flash[:notice] = 'Your information has been updated.'
      if params[:create_programmer].present?
        redirect_to edit_user_programmer_path(@user)
      elsif params[:create_client].present?
        redirect_to new_user_client_path(@user)
      else
        render :edit
      end
    else
      flash[:alert] = 'Your information could not be updated.'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :country, :state, :city, :checked_terms)
  end
end
