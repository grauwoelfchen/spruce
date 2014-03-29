class CreateRings < ActiveRecord::Migration
  def up
    create_table :rings, :id => false

    execute "ALTER TABLE rings ADD COLUMN id BIGSERIAL PRIMARY KEY;"

    change_table :rings do |t|
      t.string   :item_type, :null => false
      t.integer  :user_id
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end

    add_index :rings, [:item_type, :item_id]
    add_index :rings, :user_id
  end

  def down
    drop_table :rings
  end
end
