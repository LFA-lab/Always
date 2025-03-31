class AddDetailsToParcoursTable < ActiveRecord::Migration[8.0]
  def change
    add_reference :parcours, :owner, null: false, foreign_key: { to_table: :users }
    add_reference :parcours, :enterprise, null: false, foreign_key: true
  end
end
