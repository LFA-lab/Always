class DropSolidCacheEntries < ActiveRecord::Migration[7.0]
  def up
    drop_table :solid_cache_entries if table_exists?(:solid_cache_entries)
  end

  def down
    create_table :solid_cache_entries do |t|
      t.string :key_hash, null: false
      t.binary :data, null: false
      t.integer :byte_size, null: false
      t.timestamps
    end

    add_index :solid_cache_entries, :key_hash, unique: true
    add_index :solid_cache_entries, :byte_size
    add_index :solid_cache_entries, [:key_hash, :byte_size]
  end
end 