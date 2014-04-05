#Handles instances of the User class and makes them accesible to the view
#Ryan Pepin Drew Justus 2014
class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:user_summary, :manager_summary]
  #Index displays all the users and any comments with images that have no been approved.
  #+@users+ all the users registered on the site
  #+@comments+ only comments with images where approved is false
  def index
    @users = User.all
    @comments = Comment.where("approved = ? and image_file_name IS NOT NULL", false);
  end

  #Destoys the given user
  #+@user+ the user being destroyed
  #precondition: current use role is admin
  #postcondition: selected user no longer exists
  def destroy
    if(current_user.role != "Admin")
      owns_this?(User.find(params[:id]))#precondition check
    end
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  #Displays a home page where a poi Manager can see all pois they own
  #+@user+ the user whose pois to show
  #+@pois+ all the pois belonging to @user
  #precondition: current_user is @user
  def home
    @user = User.find(params[:id])
    owns_this?(@user.id)#precondition check
    @pois = Poi.where("user_id = ?", @user[:id])
  end

  #Displays a summary for the selected user. Shows their pois and information
  #+@user+ the user to display a summary for
  #+@pois+ the pois owned by the user
  def user_summary
    @user = User.find(params[:id])
    @pois = Poi.where("user_id = ?", @user[:id])
  end

  #Displays a list of all verified poi managers and their website.
  #+@users+ all users whose role is poimanager and verified is true
  def manager_summary
      @users = User.all(:include => :pois)
      # @users = User.where("role = ? AND verified = ?", "POIManager", true)
      # @users += User.where("role = ? AND verified = ?", "PoiManager", true)
  end

  #upgrades a users role to the requested role
  #+@user+ the user being upgraded
  #precondition the current_user role is admin
  def upgrade
    if current_user.role != "Admin"
      render :file => 'public/422.html', :layout => false
    else
      @user = User.find(params[:id])
      @user.upgrade_role()
      @user.save
      redirect_to users_path
    end

  end
  private

  def owns_this?(user_id)
    unless (current_user.id == user_id)
      render :file => 'public/422.html', :layout => false
    end
  end

end
