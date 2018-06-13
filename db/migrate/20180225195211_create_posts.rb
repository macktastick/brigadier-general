class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :reddit_id
      t.string :title, limit: 512
      t.string :permalink
      t.references :subreddit

      t.boolean :notified

      t.integer :remote_created_at

      t.timestamps
    end
  end
end
