class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column    :users, :username, :string, :after => :id
    change_column :users, :username, :string, :null => false

    add_index :users, :username, :unique => true
  end
end
