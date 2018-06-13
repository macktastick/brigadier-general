class CreateBotVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_votes do |t|
      t.references :bot_user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
