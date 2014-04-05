require 'test_helper'

class PoisControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:ryan)
    sign_in :user, @user
  end

  def setup_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:drew)
    sign_in :user, @user
  end

  test"should get index"do
    get(:index)
    assert_response :success
    assert_not_nil assigns(:pois)
  end

  test"should get show1"do
    get(:show, {'id' => "1"})
    assert_response :success
    assert assigns(:poi).title => "MyString1"
    assert_not_nil assigns(:poi)
  end
  test "should delete poi as admin" do
    setup()
    assert_difference('Poi.count', -1) do
      delete :destroy, :id => pois(:one).id
    end
  end
    test "shouldnt delete poi" do
    setup_user()#not owner/admin
    assert_difference('Poi.count', 0) do
      delete :destroy, :id => pois(:one).id
    end
  end
  
  test "should delete poi as owner" do
    setup_user()#is owner, not admin
    assert_difference('Poi.count', -1) do
      delete :destroy, :id => pois(:two).id, :remote => true
    end
  end
  
  test"should get show2"do
    get(:show, {'id' => "2"})
    assert_response :success
    assert assigns(:poi).title => "MyString2"
    assert_not_nil assigns(:poi)
  end
    test"should edit post"do
    setup()
    patch(:edit, {'id' => "1",})
    assert_response :success
    assert assigns(:poi).title => "MyString2"
    assert_not_nil assigns(:poi)
  end
  test "should create poi" do
    assert_difference('Poi.count') do
      get :create, poi: {title: 'Hello there', description: 'This is my first post.', latitude: 25, longitude: 25}, user_id: 1
    end
    assert_redirected_to poi_path(assigns(:poi))
  end

end
