require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user with no fields" do
    user = User.new
    assert !user.save
  end
  test "should save with name, role, email, password, verified" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password = "doggie123"
    user.verified = true
    assert user.save
  end
  test "should not save without first name" do
    user = User.new
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password= "doggie123"
    user.verified = true
    assert !user.save
  end
  test "should not save without last name" do
    user = User.new
    user.first_name = "Ryan"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password= "doggie123"
    user.verified = true
    assert !user.save
  end
  test "should not save without email" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.password= "doggie123"
    user.verified = true
    assert !user.save
  end
  test "should save without role and set default" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.email = "ryan665@gmail.com"
    user.password= "doggie123"
    user.verified = true
    assert user.save
    assert user.role == "user"
  end
  test "should not save without password" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.verified = true
    assert !user.save
  end
  test "should save without verified" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password= "doggie123"
    assert user.save
    assert user.verified == false
  end
  test "should not save with incorrect avatar filetype zebra" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password = "doggie123"
    user.verified = true
    user.avatar_content_type = "image/zebra"
    assert !user.save
  end
    test "should not save with incorrect avatar filetype pdf" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password = "doggie123"
    user.verified = true
    user.avatar_content_type = "image/pdf"
    assert !user.save
  end
  
    test "should save with correct avatar filetype jpeg" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password = "doggie123"
    user.verified = true
    user.avatar_content_type = "image/jpeg"
    assert user.save
  end
  
    test "should save with correct avatar filetype png" do
    user = User.new
    user.first_name = "Ryan"
    user.last_name = "Pepin"
    user.role = "user"
    user.email = "ryan665@gmail.com"
    user.password = "doggie123"
    user.verified = true
    user.avatar_content_type = "image/png"
    assert user.save
  end
  
end

# t.string   "email",               default: "",     null: false
# t.string   "encrypted_password",  default: "",     null: false
# t.datetime "remember_created_at"
# t.string   "role",                default: "user", null: false
# t.datetime "created_at"
# t.datetime "updated_at"
# t.boolean  "verified",            default: false
# t.string   "about_me"
# t.string   "private_web_url"
# t.string   "first_name",          default: "",     null: false
# t.string   "last_name",           default: "",     null: false
# t.string   "avatar_file_name"
# t.string   "avatar_content_type"
# t.integer  "avatar_file_size"
# t.datetime "avatar_updated_at"
# t.string   "provider"
# t.string   "uid"
# t.text     "requestedRole"