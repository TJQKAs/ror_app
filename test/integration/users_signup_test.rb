require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest


  # test "invalid signup information" do      -> old version
  #       get signup_path
  #       before_count = User.count
  #       post users_path, user: {name: "", nickname: "", email: "user_invalid", password: "abs", password_confirmation: "cde" }
  #       after_count = User.count
  #       assert_equal before_count, after_count
  #       assert_template 'users/new'
  # end

def setup
  ActionMailer::Base.deliveries.clear
end

test "invalid signup information" do
      get signup_path
      # assert that the count of users will not change because we aren't able to create user with the data below
          assert_no_difference "User.count" do
          post users_path, user: {name: "", nickname: "", email: "user_invalid",
          password: "abs", password_confirmation: "cde" }
          end
      assert_template 'users/new'
end

test "valid signup information" do
      get signup_path
      # assert that the count of users will not change because we aren't able to create user with the data below
          assert_difference "User.count", 1  do
          post  users_path, user: {name: "James",
                                                              nickname: "Trumble",
                                                                     email: "Jtrumble@gmail.com",
                                                               password: "123456789",
                                        password_confirmation: "123456789" }
          end
      #mail was delivered
          assert_equal 1, ActionMailer::Base.deliveries.size
      #assigns track the condition of instance :user in other methods ans files (in our case condition in user_controller )
          user = assigns(:user)
          assert_not user.activated?
          #try to login before activation
          log_in_as(user)
          assert_not is_logged_in?
          # invalid activation
          get edit_account_activation_path("Invalid token")
          assert_not is_logged_in?
          get edit_account_activation_path(user.activation_token, email: "wrong")
          assert_not is_logged_in?
          get edit_account_activation_path(user.activation_token, email: user.email)
          assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
end




end
