class Comment < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user
  has_attached_file :image, :url  => "/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :styles => {:thumbnail => '200x200#!', :medium => "400x400#!", :huge => "600x600#!"}
  do_not_validate_attachment_file_type :image #necessary because of a cocaine(required gem) bug.
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  validates :body, presence: true, length: {minimum: 1}
  validates :User_id, presence: true
  validates :poi_id, presence: true
  validates :name, presence: true
  #gets the user image of the user who made the comment
  #return - the user avatar of the user who owns this comment.
  def get_user_image
    user = User.find(self.User_id)
    return user.avatar
  end
  #Sets up some of the fields for a comment
  #+@comment+ the comment whose fields are being changed.
  def set_up(current_user)
    self.User_id = current_user
    self.name = User.find(current_user).first_name + ' ' + User.find(current_user).last_name # so we dont have to cross reference tables later(slow)
    self.approved = false#image wont be displayed untill approved by an admin
  end
  #Sets the approve field to true. This will let images attached to the comment displayable.
  def approve
    self.approved = true
  end



end
  