#Controller for creating/displaying/deleteing image objects
#Ryan Pepin Drew Justus 2014
class ImagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_PoiManager, only:[:create, :destroy]
  #Creates an instance of an image object
  #+@poi+ the poi the image(s) belongs to.
  #+@image+ the new instance of an image object
  #+@images+ all other images tied to the same poi_jd
  def new
    @poi = Poi.find(params[:poi_id])
    @image = Image.new
    @images = Image.where("poi_id = ?", params[:poi_id])
  end
  
  #Attempts to save the image object with the given parameters
  #+@poi+ the poi the image(s) belongs to.
  #+@images+ all images associated with the same poi
  #+@image+ the image to be saved
  #precondition: current_user.role == poi manager or admin. see before_filter
  def create
    @poi = Poi.find(params[:poi_id])
    @images = Image.where("poi_id = ?", params[:poi_id])
    @image = Image.create image_params
    @image.setup((params[:poi_id]), current_user.id)
    if @image.poi_image.url.include?("missing")
    @image.delete
    else if @image.save
        redirect_to new_poi_image_path(@image.poi_id)
      else
        redirect_to new_poi_image_path(@image.poi_id)
      end
    end
  end

  #destroys the selected image from the DB
  #+@image+ the image to be desroyed
  #precondition: current_user must own the image or be an admin
  def destroy
    @image = Image.find(params[:id])
    if(!owns_post?(@image.user_id) || current_user.role != "Admin")#precondition check
      render :file => 'public/422.html', :layout => false
    else
      @image.destroy
      redirect_to new_poi_image_path(Poi.find(@image.poi_id))
    end
  end
  private

  def image_params
    params.fetch(:image, {}).permit(:poi_id, :user_id, :poi_image)
  end

  def authenticate_PoiManager
    unless (((current_user.role == "PoiManager"|| current_user.role == "POIManager") && current_user.verified == true) || current_user.role == "Admin")
      @error = "Must be verified."
      render :file => 'public/422.html', :layout => false
    end
  end

  def owns_post?(user_id)
    unless (current_user.id == user_id)
    return false
    end
    return true
  end
end
