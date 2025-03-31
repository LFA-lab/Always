class CreateParcours < ActiveRecord::Migration[7.0]
  def change
    create_table :parcours do |t|
      t.string :title, null: false
      t.text :description
      t.references :enterprise, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end 