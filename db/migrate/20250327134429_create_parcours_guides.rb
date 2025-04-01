class CreateParcoursGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :parcours_guides do |t|
      t.references :parcours, null: false, foreign_key: true
      t.references :guide, null: false, foreign_key: true
      t.integer :order_in_parcours

      t.timestamps
    end
  end
end
