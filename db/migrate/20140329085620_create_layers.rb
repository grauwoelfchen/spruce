class CreateLayers < ActiveRecord::Migration
  def up
    create_table :layers, :id => false

    execute "ALTER TABLE layers ADD COLUMN id BIGSERIAL PRIMARY KEY;"

    change_table :layers do |t|
      t.string   :item_type, :null => false
      t.integer  :user_id
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end

    add_index :layers, [:item_type, :item_id]
    add_index :layers, :user_id
  end

  def down
    drop_table :layers
  end
end
