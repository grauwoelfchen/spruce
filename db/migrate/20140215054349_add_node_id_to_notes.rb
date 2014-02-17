class AddNodeIdToNotes < ActiveRecord::Migration
  def change
    add_column    :notes, :node_id, :integer, :after => :user_id
    change_column :notes, :node_id, :integer, :null => false

    add_index :notes, :node_id
    add_index :notes, [:user_id, :node_id, :name], :unique => true
  end
end
