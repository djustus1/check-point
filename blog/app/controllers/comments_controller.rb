##Comments controller handles the creation, deletiion, and showing of comments.
#
#Ryan Pepin Drew Justus 2014
#
class CommentsController < ApplicationController

  before_action :authenticate_user! #makes sure the user is logged in for all actions
  
  #
  #Create makes a new comment with the parameters from the form.
  #precondition: user must be logged in (see before action)
  #postcondition: the poi has one new comment 
  def create
    @poi = Poi.find(params[:poi_id])
    @comment = @poi.comments.create(comment_params)
    @comment.set_up(current_user.id)
    @comment.save
    redirect_to poi_path(@poi)
  end
  #
  #Destroy removes a comment from the database/poi. To destroy a comment you must be an admin or the creator of the comment
  #precondition: user is admin / user owns comment
  #postcondition: the poi no longer contains the selected comment
  def destroy
    @poi = Poi.find(params[:poi_id])
    @comment = @poi.comments.find(params[:id])
    if(!owns_post?(@comment.User_id) && current_user.role != "Admin")#precondition check
      render :file => 'public/422.html', :layout => false
    else
      @comment.destroy
      redirect_to poi_path(@poi)
    end

  end

  #
  # Verifies a comment. A verified comment will have its image displayed.
  # +@comment+ the comment to be verified
  # precondition: current_user.role == admin
  # postcondition: comment.verified == true
  def verify
    if(current_user.role != "Admin")
      render :file => 'public/422.html', :layout => false
    else
      @comment = Comment.find(params[:comment_id])
      @comment.approve()
      @comment.save
      redirect_to users_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image, :user_id, :name)
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