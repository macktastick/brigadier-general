class Post < ApplicationRecord

  belongs_to :subreddit

  has_many :alerts
  has_many :observations
  has_many :links

end
