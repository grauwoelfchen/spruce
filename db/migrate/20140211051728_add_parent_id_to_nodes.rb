class AddParentIdToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :parent_id, :integer, :limit => 8, :default => nil, :after => :id

    add_index :nodes, :parent_id
    add_index :nodes, [:parent_id, :user_id, :name], :unique => true
  end
end
