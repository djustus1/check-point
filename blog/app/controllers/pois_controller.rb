##
#Class for creating/editing/deleteing/displaying Points of interst(POIs)
#Ryan Pepin Drew Justus 2014
class PoisController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authenticate_PoiManager, only:[:create, :destroy, :edit, :new]
  ##
  #Index displays all pois and a map of their locations
  # +@pois+ all pois
  # +@hash+ hash of map markers and data generated from the pois
  def index
    @pois = Poi.all
    @hash = Gmaps4rails.build_markers(@pois) do |poi, marker|
      marker.lat poi.latitude
      marker.lng poi.longitude
      marker.title   poi.title
      marker.json({ :id => poi.id})
      marker.infowindow render_to_string(:partial => "/pois/show", :locals => { :poi => poi})
    end
  end

  #Makes a new intsance of a poi and makes it accessible to the view.
  # +@poi+ the new poi object
  def new
    @poi = Poi.new
  end

  #Saves the instance of poi into the database with the given parameters.
  # +@poi+ the poi object just created
  #
  def create
    @poi = Poi.new(poi_params)
    @poi.user = current_user
    if @poi.save
      redirect_to poi_path(@poi)
    else
      render 'new'
    end
  end

  #Edit makes the requested poi availble to the view to be edited.
  # +@poi+ the poi being edited.
  #precondition: user must own this poi
  def edit
    (owns_post?(Poi.find(params[:id]).user_id))
    @poi = Poi.find(params[:id])
  end

  #Show makes a single poi availble. Show also makes the user who created this poi available,
  # and images associated with the poi available.
  # +@poi+ the poi being shown
  # +@user+ the user who owns the poi object
  # +@images+ all the images owned by the poi object
  # +@comments+ all the comments owned by the poi object
  # +@hash+ marker data for google map
  def show
    @poi = Poi.find(params[:id])
    @user = User.find(@poi[:user_id])
    @images = Image.where("poi_id = ?", @poi[:id])
    @comments = Comment.where("poi_id = ?", @poi[:id])
    @hash = Gmaps4rails.build_markers(@poi) do |poi, marker|
      marker.lat poi.latitude
      marker.lng poi.longitude
    end
  end

  #Update makes the specified poi availble in the view. If it updates correctly the user is taken to the poi.
  # +@poi+ the poi being edited
  #precondition: current_user must own poi.
  def update
    (owns_post?(Poi.find(params[:id]).user_id))#precondition check
    @poi = Poi.find(params[:id])
    if @poi.update(poi_params)
      redirect_to poi_path(@poi.id)
    else
      render 'edit'
    end
  end

  #Destroy deletes the selected poi from the db and redirects the user to the root path.
  # +@poi+ the poi being deleted
  # precondition: current_user must own poi || current_user role == admin
  # postcondition: @poi.exists? == false
  def destroy
    if (current_user.role != "Admin")
      owns_post?(Poi.find(params[:id]).user_id)#precondition
    end
      @poi = Poi.find(params[:id])
      @poi.destroy
      redirect_to root_path
    
  end

  private

  #Specifies what paramaters are permitted to be accepted by the constructor during poi creation and editing.
  def poi_params
    params.require(:poi).permit(:title, :description, :longitude, :latitude, :image, :image_delete)
  end

  ##Ensures that the current user is a Poi manager and verified, or an admin. If they are not, they are redirected.
  def authenticate_PoiManager
    unless (((current_user.role == "PoiManager"|| current_user.role == "POIManager") && current_user.verified == true) || current_user.role == "Admin")
      @error = "Must be verified."
      render :file => 'public/422.html', :layout => false
    end
  end

  def owns_post?(user_id)
    unless (current_user.id == user_id)
      render :file => 'public/422.html', :layout => false
    end
  end
end

