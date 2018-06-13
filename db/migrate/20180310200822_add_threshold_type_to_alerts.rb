class AddThresholdTypeToAlerts < ActiveRecord::Migration[5.1]
  def change
    add_column :alerts, :threshold_type, :string
  end
end
