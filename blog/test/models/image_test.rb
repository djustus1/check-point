require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save image without anything" do
    image = Image.new
    assert !image.save
  end
  test "should save image with poi_id, user_id" do
    image = Image.new
    image.user_id = 1
    image.poi_id = 1
    assert image.save
  end
  test "should not save image without poi_id" do
    image = Image.new
    image.user_id = 1
    assert !image.save
  end
  test "should not save image without user_id" do
    image = Image.new
    image.poi_id = 1
    assert !image.save
  end
  test "should not save image with wrong file type zebra" do
    image = Image.new
    image.poi_id = 1
    image.user_id = 1
    image.poi_image_content_type = "image/zebra"
    assert !image.save
  end
  test "should not save image with wrong file type pdf" do
    image = Image.new
    image.poi_id = 1
    image.user_id = 1
    image.poi_image_content_type = "image/pdf"
    assert !image.save
  end
  test "should save image with jpeg file type" do
    image = Image.new
    image.poi_id = 1
    image.user_id = 1
    image.poi_image_content_type = "image/jpeg"
    assert image.save
  end
    test "should save image with png file type" do
    image = Image.new
    image.poi_id = 1
    image.user_id = 1
    image.poi_image_content_type = "image/png"
    assert image.save
  end
  

end

# t.integer  "poi_id"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.string   "poi_image_file_name"
# t.string   "poi_image_content_type"
# t.integer  "poi_image_file_size"
# t.datetime "poi_image_updated_at"
# t.integer  "user_id"