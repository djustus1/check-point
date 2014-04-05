#Poi model class. Represents a point of interest.
#Ryan Pepin Drew Justus 2014
class Poi < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
  has_many :images, dependent: :destroy

  has_attached_file :image, :default_url => "/images/missing.png", :url  => "/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :styles => {:thumbnail => '200x200#!', :medium => "400x400#!", :huge => "600x600#!"}
  do_not_validate_attachment_file_type :image #due to a bug with cocaine gem and windows
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  validates_attachment_size :image, :less_than => 5.megabytes

  validates :title, presence: true,
                    length: { minimum: 5 }
  validates :longitude, presence: true, length: { minimum: 3}, numericality: { greater_than: -180, less_than: 180 }
  validates :latitude, presence: true, length: { minimum: 3}, numericality: { greater_than:  -90, less_than:  90 }
    def gmaps4rails_infowindow
      "<img src=\"#{self.image.url}\"> #{self.title}"
    end

  before_save :destroy_image?
  
  #returns the value of image_delete
  def image_delete
    @image_delete ||= "0"
  end
  #Sets image_delete to the value
  #params(value) the value of the delete image check box. 0/1
  def image_delete=(value)
    @image_delete = value
  end

  private
  #If the user selects the delete imgae check box, this method will clear the image
  #Postcondition: this.image.url == :default_url
  def destroy_image?
    self.image.clear if @image_delete == "1"
  end

end
