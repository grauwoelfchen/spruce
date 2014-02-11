class CreateNodeHierarchies < ActiveRecord::Migration
  def change
    create_table :node_hierarchies, :id => false do |t|
      t.integer :ancestor_id,   :null => false
      t.integer :descendant_id, :null => false
      t.integer :generations,   :null => false
    end

    add_index :node_hierarchies, [:ancestor_id, :descendant_id, :generations],
      :unique => true,
      :name   => "index_nodes_on_anc_and_desc_and_gens"
    add_index :node_hierarchies, [:descendant_id],
      :name => "index_nodes_on_desc"
  end
end
