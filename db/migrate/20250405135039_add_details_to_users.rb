class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nickname, :string
    add_column :users, :bio, :text
    add_column :users, :daily_goal, :integer
  end
end
