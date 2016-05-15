require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:micky)
    @other_user = users(:james)
  end

 test "should redirect index when user is unlogged in" do
   get :index
   assert_redirected_to login_url
 end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when user is unlogged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when user is unlogged in" do
    patch :update, id: @user, user: {name: @user.name, nickname: @user.nickname, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as a wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as a wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name: @user.name, nickname: @user.nickname, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy to unlogged in user" do
    assert_no_difference "User.count" do
    delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  test "should redirect destroy in case when logged in user isn't admin" do
   log_in_as(@other_user)
   assert_no_difference "User.count" do
   delete :destroy, id: @user
   end
   assert_redirected_to root_url
  end

end
