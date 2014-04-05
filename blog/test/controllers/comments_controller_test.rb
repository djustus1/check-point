require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
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

  test "should create comment" do
    setup()
    assert_difference('Comment.count') do
      post :create, poi_id: 1, comment: {body: 'Some title', User_id: 1, poi_id: 1, approved: false}
    end
  end
  
  test "shouldnt create comment with no body" do
    setup()
    assert_difference('Comment.count', 0) do
      post :create, poi_id: 1, comment: {body: '', User_id: 1, poi_id: 1, approved: false}
    end
  end
  
  test "shouldnt delete comment " do
    setup_user()#user is not admin or comment owner.
    assert_difference('Comment.count', 0) do
      delete :destroy, :poi_id => pois(:one).id, :id => comments(:one).id
    end
  end
    # test "should delete comment as owner " do
    # setup_user()#user is comment owner.
    # assert_difference('Comment.count', -1) do
      # delete :destroy, :poi_id => pois(:one).id, :id => comments(:four).id
    # end
  # end

  test "should verify comment" do
    setup()
      post :verify, :comment_id => comments(:one).id do
      assert_equal true, comments(:one).approved
      end
  end
    test "shouldnt verify comment" do
    setup_user()#not an admin
      post :verify, :comment_id => comments(:one).id do
      assert_equal false, comments(:one).approved
      end
  end
end
