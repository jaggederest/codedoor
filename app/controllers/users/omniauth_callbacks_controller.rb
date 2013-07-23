class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_github_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
    end
  end

  # TODO: add a message about the login failure
  def failure
    redirect_to root_path
  end
end
