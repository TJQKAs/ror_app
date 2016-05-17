require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
 def setup
   @user = users(:micky)
end

   test "profile display" do
     get user_path(@user)
     assert_template "users/show"
    #  assert_select 'title',"#{@user.name} | Ruby on Rails Tutorial Sample Application"
    assert_select 'title', full_title(@user.name)
    assert_select 'h1',  text: @user.name
    assert_select 'h1',  text: @user.nickname
    assert_select 'h1',  text: @user.email
    assert_select 'h1> img.gravatar'
#by test below we expect to see @user.microposts.count.to_s
#somewhere in the pweb page
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end 
end


end
