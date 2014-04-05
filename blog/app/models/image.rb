#Model of an image object. Is associated to a poi.
#Ryan Pepin Drew Justus 2014
class Image < ActiveRecord::Base
  has_attached_file :poi_image, :url  => "/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :styles => {:thumbnail => '200x200#!', :medium => "400x400#!", :huge => "600x600#!"}
  do_not_validate_attachment_file_type :poi_image
  validates_attachment_content_type :poi_image, :content_type => ['image/jpeg', 'image/png']
  validates_attachment_size :poi_image, :less_than => 5.megabytes 
  belongs_to :poi
  belongs_to :user
  validates :user_id, presence: true
  validates :poi_id, presence: true
  #Sets some inital parameters of the image object.
  #params(poi_id) the id of the poi object who owns the comment
  #params(user_id) the id of the user who owns the comment
  def setup(poi_id,user_id)
    self.poi_id = (poi_id)
    self.user_id = user_id
  end
end
