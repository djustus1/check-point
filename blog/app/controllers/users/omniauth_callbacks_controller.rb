#Class for allowing users to log in via facebook/google+
#Ryan Pepin Drew Justus 2014
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #Allows a user to sign in via facebook
  #+@user+ the user signing in
  def facebook   
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  #Allows a user to sign in via google+
  #+@user+ the user signing in
  def google_oauth2
        @user = User.find_for_google_oauth2(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else#sign in with the user if the account exists or create one if it can, else take them to the register form.
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end