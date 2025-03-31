class CreateGuides < ActiveRecord::Migration[8.0]
  def change
    create_table :guides do |t|
      t.string :title
      t.text :description
      t.integer :visibility
      t.string :slug
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :enterprise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
