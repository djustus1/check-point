#Model representing a user.
#Ryan Pepin Drew Justus 2014
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :recoverable
  has_many :pois, dependent: :destroy
  has_many :comments, dependent: :destroy
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  do_not_validate_attachment_file_type :avatar
  has_attached_file :avatar, :default_url => "/images/missing.png", :url  => "/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/images/:class/:attachment/:id_partition/:style/:basename.:extension",
                    :styles => {:thumbnail => '200x200#!', :medium => "400x400#!", :huge => "600x600#!"}
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates :first_name, presence: true, length: { minimum: 2}
  validates :last_name, presence: true, length: { minimum: 2}
  validates :email, length: { minimum: 5}
  validates :role, presence: true
  validates_format_of :email, :with => /\A.+@.+\..+\z/

  before_save :destroy_avatar?
  
  #Creates a new user if their account doesn't already exist, from facebook. Courtesy of oauth gem website.
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  #upgrades the user's role and sets their requested role back to blank.
  def upgrade_role
      self.role = self.requestedRole
      self.requestedRole = ""
  end
  #returns the default value of avatar_delete, 0
  def avatar_delete
    @avatar_delete ||= "0"
  end
  #sets the value of avatar delete to value
  #param(value) the value to set avatar delete to. 0/1
  def avatar_delete=(value)
    @avatar_delete = value
  end
  #Gets fields for creating a new user from facebook using oauth
  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.role = "User"
      user.avatar = URI.parse(auth.info.image) if (auth.info.image?)
    end
  end
  #Gets fields for creating a new user from google plus using oauth
  def self.find_for_google_oauth2(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.role = "User"
      user.avatar = URI.parse(auth.info.image) if (auth.info.image?)
    end
  end
  #Sets the verify field for this user to true.
  def verify
    self.verified = true
  end
  private

  def destroy_avatar?
    self.avatar.clear if @avatar_delete == "1"
  end

end
