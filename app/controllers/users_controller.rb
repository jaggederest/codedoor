class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if current_user.update(user_params)
      flash[:notice] = 'Your information has been updated.'
      # TODO: redirect should depend on the button pressed.
      redirect_to edit_user_programmer_path(@user)
    else
      flash[:alert] = 'Your information could not be updated.'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :country, :checked_terms)
  end

end
