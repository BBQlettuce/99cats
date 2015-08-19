class FixSessionTokenCol < ActiveRecord::Migration
  def change
    remove_column :users, :session_token
    add_column :users, :session_token, :string
  end
end
