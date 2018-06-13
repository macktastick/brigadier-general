class BotVote < ApplicationRecord
  belongs_to :bot_user
  belongs_to :post
end
