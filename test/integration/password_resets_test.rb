require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:micky)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # wrong password
    post password_resets_path, password_reset: {email: ""}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    post password_resets_path, password_reset: {email: @user.email}
    assert_not_equal  @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # password reset form
    user = assigns(:user)
    # wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # right mail wrong token
    get edit_password_reset_path('wrong_token', email: user.email)
    assert_redirected_to root_url
    # right email rigth token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
  # invalid password or confirmation
  patch password_reset_path(user.reset_token),
  email: user.email,
  user: {password: "hokahoka",
            password_confirmation: "gogogogo"}
   assert_select "div#error_explanation"
  #  Empty pass&confirmation
  patch password_reset_path(user.reset_token),
  email: user.email,
  user: {password: "",
            password_confirmation: "hokahoka"}
   assert_not flash.empty?
   assert_template 'password_resets/edit'
  # valid password or confirmation
  patch password_reset_path(user.reset_token),
  email: user.email,
  user: {password: "hokahoka",
            password_confirmation: "hokahoka"}
assert is_logged_in?
assert_not flash.empty?
assert_redirected_to user
  end
end
