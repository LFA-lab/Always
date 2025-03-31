class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :guide, foreign_key: true
      t.string :action_type, null: false
      t.string :element_type, null: false
      t.string :element_selector, null: false
      t.text :element_text
      t.string :screenshot_url
      t.datetime :timestamp, null: false
      t.json :metadata

      t.timestamps
    end

    add_index :interactions, [:user_id, :created_at]
    add_index :interactions, [:guide_id, :created_at]
  end
end 