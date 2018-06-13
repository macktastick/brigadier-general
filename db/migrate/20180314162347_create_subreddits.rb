class CreateSubreddits < ActiveRecord::Migration[5.1]
  def change
    create_table :subreddits do |t|
      t.string :name
      t.string :notify
      t.integer :post_monitoring_period
      t.boolean :coarse_filter_enabled
      t.integer :coarse_filter_period
      t.integer :coarse_filter_up_vote_threshold
      t.integer :coarse_filter_comment_threshold
      t.boolean :medium_filter_enabled
      t.integer :medium_filter_period
      t.integer :medium_filter_up_vote_threshold
      t.integer :medium_filter_comment_threshold
      t.boolean :fine_filter_enabled
      t.integer :fine_filter_period
      t.integer :fine_filter_up_vote_threshold
      t.integer :fine_filter_comment_threshold

      t.timestamps
    end
  end
end
