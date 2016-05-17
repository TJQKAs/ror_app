require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

def setup
  @user = users(:micky)
  # @micropost = Micropost.new(content: "Sic transit gloria mundi", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Sic transit gloria mundi")
end
  # check whether micropost is valid
    test "should be valid" do
      assert @micropost.valid?
    end

    test "user id should be present" do
     @micropost.user_id = nil
     assert_not @micropost.valid?
    end

    test "content shouldn't be blankt" do
     @micropost.content= "    "
     assert_not @micropost.valid?
    end

    test "content shouldn't be more than 140 chars" do
     @micropost.content= "a" * 141
     assert_not @micropost.valid?
    end

    test "order should be most recent first" do
      assert_equal Micropost.first, microposts(:most_recent)
    end


end
