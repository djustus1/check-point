#This class is part of the devised gem, modified slightly by Ryan Pepin and Drew Justus
class Devise::RegistrationsController < DeviseController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  before_filter :configure_permitted_parameters
  # GET /resource/sign_up
  def new
    build_resource({})
    respond_with self.resource
  end

  #revokes the posting privleges of the user
  #+@user+ the user to revoke privleges for.
  def revoke
    @user = User.find(params[:id])
    @user.verified = false
    @user.save
    redirect_to users_path
  end

  # POST /resource
  def create

    build_resource(sign_up_params)
    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        puts :notice
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    @user = current_user
    User.reset_column_information
    render :edit
  end
  
  #Approves the user to post content
  #+@user+ the user to be verified
  def approve
    @user = User.find(params[:id])
    @user.verify()
    @user.save
    redirect_to users_path
  end
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    @user = User.find(current_user.id)
    if (params[:user][:requestedRole] != current_user.role && params[:user][:requestedRole] != 'Admin')
        @user.role = params[:user][:requestedRole]
        params[:user][:requestedRole] = "" 
    end
    if(params[:user][:requestedRole] == current_user.role)
      params[:user][:requestedRole] = ""
    end
    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path(@user)
    else
      render "edit"
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
    resource.pending_reconfirmation? &&
    previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :private_web_url, :role, :about_me,
      :email, :password, :password_confirmation, :avatar, :avatar_delete, :requestedRole)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:private_web_url, :about_me,
      :password, :password_confirmation, :current_password, :avatar, :avatar_delete, :requestedRole, :first_name, :last_name)
    end
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)

  end

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
    params[:user][:password].present?
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end
end