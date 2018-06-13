class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.integer :post_id
      t.integer :observation_id

      t.timestamps
    end
  end
end
