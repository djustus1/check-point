require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without anything" do
    comment = Comment.new
    assert !comment.save
  end
   test "should not save comment without body" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.approved = false
    comment.name = "Ryan Pepin"
    assert !comment.save
  end  
  
   test "should not save comment without poi_id" do
    comment = Comment.new
    comment.User_id = 1
    comment.approved = false
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    assert !comment.save
  end  
     test "should not save comment without user_id" do
    comment = Comment.new
    comment.poi_id = 1
    comment.approved = false
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    assert !comment.save
  end  
     test "should save comment without approved" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    assert comment.save
  end  
       test "should save comment with all minus image" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    comment.approved = false
    assert comment.save
  end  
    test "should not save comment without name" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.approved = false
    assert !comment.save
  end 
  
    test "should not save comment with wrong image file type zebra" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    comment.approved = false
    comment.image_content_type = "image/zebra"
    assert !comment.save
  end 
    test "should not save comment with wrong image file type pdf" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    comment.approved = false
    comment.image_content_type = "image/pdf"
    assert !comment.save
  end 
      test "should save comment with jpeg image" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    comment.approved = false
    comment.image_content_type = "image/jpeg"
    assert comment.save
  end 
      test "should save comment with png image" do
    comment = Comment.new
    comment.poi_id = 1
    comment.User_id = 1
    comment.body = "my body"
    comment.name = "Ryan Pepin"
    comment.approved = false
    comment.image_content_type = "image/png"
    assert comment.save
  end 
end
    # t.text     "body"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.integer  "poi_id"
    # t.string   "image_file_name"
    # t.string   "image_content_type"
    # t.integer  "image_file_size"
    # t.datetime "image_updated_at"
    # t.boolean  "approved"
    # t.integer  "User_id"
    # t.string   "name"