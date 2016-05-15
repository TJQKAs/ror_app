require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

def setup
  @user = users(:micky)
end



 test "unsuccessful edit" do
  log_in_as(@user)
  get edit_user_path(@user)
  assert_template 'users/edit'
  patch user_path(@user), user: {name: "",
                                                 nickname: "",
                                                 email: "user_invalid",
                                                 password: "abs",
                                                 password_confirmation: "cde" }
   assert_template 'users/edit'
 end

   test "successful edit with friendly forwearding " do
   get edit_user_path(@user)
   log_in_as(@user)
   assert_redirected_to edit_user_path(@user)
   patch user_path(@user), user: {  name: "James",
                                                       nickname: "Trumble",
                                                              email: "Jtrumble@gmail.com",
                                                        password: "",
                                 password_confirmation: "" }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal @user.name, "James"
    assert_equal @user.nickname, "Trumble"
  end
end
