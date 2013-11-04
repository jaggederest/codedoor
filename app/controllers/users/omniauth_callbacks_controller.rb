class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_github_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # This will throw if @user is not activated
    end
  end

  def failure
    flash[:alert] = 'Unfortunately, there has been a problem with GitHub login.'
    redirect_to root_path
  end
end
