class CreateParcours < ActiveRecord::Migration[8.0]
  def change
    create_table :parcours do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
