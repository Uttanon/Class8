class User < ApplicationRecord
  has_secure_password
  has_many :posts
  validates :email, uniqueness: true
  validates :name, uniqueness: true
  validates :name, :email, :password, presence: true
  validates :password, length: { minimum: 4, maximum: 20}
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :following_users
  
  def get_feed_post
  	@user = self
  	@allpost = Array.new
  	User.find(@user.id).followees.each do |followee|
		followee.posts.each do |post|
			@allpost.push(post)
		end
	end
	@allpost = @allpost.sort_by{ |created_at| created_at }
  end
end
