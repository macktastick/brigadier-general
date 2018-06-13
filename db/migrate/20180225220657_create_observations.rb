class CreateObservations < ActiveRecord::Migration[5.1]
  def change
    create_table :observations do |t|
      t.integer :post_id
      t.integer :up_votes
      t.integer :down_votes
      t.integer :comment_count

      t.timestamps
    end
  end
end
