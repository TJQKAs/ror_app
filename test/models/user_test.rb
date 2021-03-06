require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Username", nickname:"UserNick", email: "axxxaa@com.ru",
                                   password: "legomego", password_confirmation: "legomego")
  end

# check whether user is valid
  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not  @user.valid?
  end

  test "nickname should be present" do
    @user.nickname = ""
    assert_not  @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not  @user.valid?
  end

# test of length validation of the name
test "name shouldn't be too long" do
  @user.name = "a" * 31
  assert_not @user.valid?
end

test "nickname shouldn't be too long" do
  @user.nickname = "a" * 256
  assert_not @user.valid?
end
# validation of length email
test "email shouldn't be too long and to short" do
  @user.email = "a" * 31
  @user.email = "a" * 4
  assert_not @user.valid?
end

test "email validation should accept valid addresses" do
  valid_addresses = %w[axxxaa@.com User@gmail.com S_John@rambler.ru]
  valid_addresses.each do |valid_address|
    @user.email = valid_address
    assert @user.valid?, "#{valid_address.inspect} should be valid"
  end
end

test "email validation should reject invalid addresses" do
  invalid_addresses = %w[af,@gmai.com D$fg.com rhino:20@mail.ru]
  invalid_addresses.each do |invalid_address|
    @user.email = invalid_address
    assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  end
end

 test "each user has unique email" do
   duplicate_user = @user.dup
   duplicate_user.email = @user.email.upcase
   @user.save
   assert_not duplicate_user.valid?
 end

 test "password should be at least 8 chars" do
   @user.password = @user.password_confirmation = "a" * 7
   assert_not @user.valid?
 end

 test "authenticated? should return false for a user with nil digest" do
   assert_not @user.authenticated?(:remember,"")
 end

test "associated microposts should be destroyed" do
  @user.save
  @user.microposts.create!(content: "Nice comment")
  assert_difference "Micropost.count", -1 do
    @user.destroy
  end
  end

  test "should follow and unfollow user" do
    micky = users(:micky)
    james = users(:james)
    assert_not micky.following?(james)
    micky.follow(james)
    assert micky.following?(james)
    assert james.followers.include?(micky)
    micky.unfollow(james)
    assert_not micky.following?(james)
  end

  test "feed should have the right posts" do
    micky = users(:micky)
    dicky = users(:dicky)
    bames = users(:bames)
    james = users(:james)
    #followed user
    bames.microposts.each do |post_following|
      assert micky.feed.include?(post_following)
    end
    #post from self
    micky.microposts.each do |post_self|
    assert micky.feed.include?(post_self)
   end
   #Posts from unfollowed users
#      james.microposts.each do |post|
#      assert_not micky.include?(post)
# end
end
end
