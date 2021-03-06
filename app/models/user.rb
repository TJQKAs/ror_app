class User < ActiveRecord::Base
    # each user has many posts dependent::destroy -> microposts will disappear in case user will have been destroyed
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                                      foreign_key: "follower_id",
                                                      dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                                      foreign_key: "followed_id",
                                                      dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower



  attr_accessor :remember_token, :activation_token, :reset_token
  #we want that all emails will be converted to lowercase view before we
  #save it in data base
  before_save  :downcase_email
  # checks that we have name
  before_create :create_activation_digest
  validates  :name,            presence: true, length: {maximum: 30}
  validates  :nickname,     presence: true, length: {maximum: 255}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\z/
  validates  :email,            presence: true, length: {maximum: 30, minimum: 5},
                                         format: {with: VALID_EMAIL_REGEX},
                                         uniqueness: {case_sensetive: false}
  #add functionality for secure password
  has_secure_password
  validates  :password,  length: {minimum: 8}, allow_blank: true

  # returns the hash digest of user
  def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                                                        BCrypt::Engine.cost
                                                                                        BCrypt::Password.create(string, cost: cost)
  end

  # returns random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remember user in db for use in persistent session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end


 def forget
       update_attribute(:remember_digest, nil)
 end


  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
  # returns true if the given token matches the digest
    return false if digest.nil?
     BCrypt::Password.new(digest).is_password?(token)
  end

# activate and account
def activate
  self.update_attribute(:activated, true)
  self.update_attribute(:activated_at, Time.zone.now)
end

# sends activation email
def send_activation_email
      UserMailer.account_activation(self).deliver_now
end

#sets the password's reset attributes
def  create_reset_digest
  self.reset_token = User.new_token
  update_attribute(:reset_digest, User.digest(reset_token))
  update_attribute(:reset_sent_at, Time.zone.now)
end

# sends password reset  email
def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
end

# returns true in case expiration time has run out
def password_reset_expired?
reset_sent_at  < 2.hours.ago
end
#returns status of the user's feed
def feed
  following_ids_subselect = "SELECT followed_id FROM relationships
                                               WHERE follower_id = :user_id"
  Micropost.where("user_id IN (#{following_ids_subselect})
                              OR user_id = :user_id", user_id: id)
end

# to user's following
def  follow(other_user)
  active_relationships.create(followed_id: other_user.id)
end

# to user's unfollowing
def  unfollow(other_user)
  active_relationships.find_by(followed_id: other_user.id).destroy
end

# returns true in case user follows
def following?(other_user)
  self.following.include?(other_user)
  # !active_relationships.find_by(followed_id: other_user.id).nil?
end

  private

  # convert to lowercase
   def downcase_email
    self.email = email.downcase
   end

  # create and confirm the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
