class CreateBotUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_users do |t|
      t.string :email
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
