require 'test_helper'

class PoiTest < ActiveSupport::TestCase

  # test "the truth" do
  #   assert true
  # end
  test "should not save poi without anything" do
    poi = Poi.new
    assert !poi.save
  end
  test "should not save poi without latitude " do
    poi = Poi.new
    poi.title = "my title"
    poi.description = "description"
    poi.longitude = 25.00
    assert !poi.save
  end
  test "should not save poi without longitude" do
    poi = Poi.new
    poi.title = "my title"
    poi.description = "description"
    poi.latitude = 24.42
    assert !poi.save
  end
  test "should not save poi without title" do
    poi = Poi.new
    poi.description = "description"
    poi.latitude = 24.42
    poi.longitude = 25.00
    assert !poi.save
  end
  test "should save poi without description " do
    poi = Poi.new
    poi.title = "my title"
    poi.latitude = 24.42
    poi.longitude = 25.00
    assert poi.save
  end
      test "should not save with out of bounds longitude " do
    poi = Poi.new
    poi.title = "my title"
    poi.description = "description"
    poi.latitude = 24.42
    poi.longitude = 255.00
    assert !poi.save
  end
      test "should not save poi with out of bounds latitude " do
    poi = Poi.new
    poi.title = "my title"
    poi.description = "description"
    poi.latitude = 324.42
    poi.longitude = 25.00
    assert !poi.save
  end

end
    # t.string   "title"
    # t.integer  "user_id"
    # t.text     "description"
    # t.float    "latitude"
    # t.float    "longitude"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.string   "image_file_name"
    # t.string   "image_content_type"
    # t.integer  "image_file_size"
    # t.datetime "image_updated_at"
