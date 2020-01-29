class User < ApplicationRecord
  # Microposts
  has_many :microposts, dependent: :destroy

  # Following Function
  # Followed Users
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  # Followers
  has_many :reverse_relationships, foreign_key: "followed_id",
            class_name:  "Relationship",
            dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # Basic Model needs for Signup and Login
  validates :name, presence: true, length: { minimum: 5 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    # Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by(self)
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  # Follows a user
  def follow(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
