require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
 def setup
 @micropost = microposts(:orange)
 end

test "should redirect create when not logged in" do
  assert_no_difference 'Micropost.count' do
    post :create, micropost: {content: "My micropost here"}
  end
  assert_redirected_to login_url
end

test "should redirect destroy when user isn't logged in" do
  assert_no_difference 'Micropost.count' do
    delete :destroy, id: @micropost
  end
  assert_redirected_to login_url
end

test "should redirect destroy for wrong micropost" do
  log_in_as(users(:micky))
  assert_no_difference "Micropost.count" do
    delete :destroy, id: microposts(:ants)
  end
end

end
