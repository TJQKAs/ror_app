require 'test_helper'


class UsersLoginTest < ActionDispatch::IntegrationTest

      def setup
        @user = users(:micky)
      end

      # we create test  1) login with invalid data 2) get error message
      # 3) we want to see user page, and logout and user link , we don't want see login link
     test "login with invalid information" do
       get login_path
       assert_template 'sessions/new'
       post login_path, session: { email: "", password: ""}
       assert_template 'sessions/new'
       assert_not flash.empty?
       get root_path
       assert flash.empty?
     end

     # we create test  1) login with valid data 2) get error message
     # 3) we want to see only one time this error message
    test "login with valid information and follow by logout" do
      get login_path
      post login_path, session: { email: @user.email, password: "password"}
      assert is_logged_in?
      assert_redirected_to @user
      follow_redirect!
      assert_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(@user)
      delete logout_path
      assert_not is_logged_in?
      assert_redirected_to root_url
      # simulate clicking logout in a second window - double logout
      delete logout_path
      follow_redirect!
      # skip
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,           count: 0
      assert_select "a[href=?]", user_path(@user),  count: 0
    end

    test "login with remembering" do
      log_in_as(@user, remember_me: '1')
      assert_not_nil cookies['remember_token']
    end

      test "login without remembering" do
        log_in_as(@user, remember_me: '0')
        assert_nil cookies['remember_token']
      end

end
