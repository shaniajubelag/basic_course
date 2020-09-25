class User < ApplicationRecord
  # Microposts
  has_many :microposts, dependent: :destroy

  # Following Function
  # Followed Users
  has_many :active_relationships, foreign_key: "follower_id",
                                  class_name: "Relationship",
                                  dependent: :destroy
  # user.active_relationships.followed_id -> user.followed_users
  has_many :followed_users, through: :active_relationships, source: :followed

  # Followers
  has_many :passive_relationships, foreign_key: "followed_id", # no conflict because they have different FK
                                    class_name: "Relationship", # able to use the same table
                                    dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # Basic Model needs for Signup and Login
  validates :name, presence: true, length: { minimum: 5 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  has_secure_password

  def feed 
    Micropost.where("user_id = ?", id)
    # Micropost.find(id)
    # Micropost.find_by(user_id: id)
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  # Follows a user
  def follow(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
end
