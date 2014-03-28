class CreateVersions < ActiveRecord::Migration
  def up
    create_table :versions, :id => false

    execute "ALTER TABLE versions ADD COLUMN id BIGSERIAL PRIMARY KEY;"

    change_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :user_id
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end

    add_index :versions, [:item_type, :item_id]
    add_index :versions, :user_id
  end

  def down
    drop_table :versions
  end
end
