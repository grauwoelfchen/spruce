class CreateCycles < ActiveRecord::Migration
  def up
    create_table :cycles, :id => false

    execute "ALTER TABLE cycles ADD COLUMN id BIGSERIAL PRIMARY KEY;"

    change_table :cycles do |t|
      t.string   :item_type, :null => false
      t.integer  :user_id
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end

    add_index :cycles, [:item_type, :item_id]
    add_index :cycles, :user_id
  end

  def down
    drop_table :cycles
  end
end
