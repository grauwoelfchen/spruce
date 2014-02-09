class AddUserIdToNotes < ActiveRecord::Migration
  def change
    add_column    :notes, :user_id, :integer, :after => :id
    change_column :notes, :user_id, :integer, :null => false

    add_index :notes, :user_id
  end
end
