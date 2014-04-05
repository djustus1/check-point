require 'test_helper'

class ImagesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:ryan)
    sign_in :user, @user
  end

  def setup_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:lowuser)
    sign_in :user, @user
  end
end
