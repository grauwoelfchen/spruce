class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes, :id => false

    execute "ALTER TABLE nodes ADD COLUMN id BIGSERIAL PRIMARY KEY;"

    change_table :nodes do |t|
      t.string  :name
      t.integer :user_id

      t.timestamps
    end

    add_index :nodes, :user_id
  end
end
