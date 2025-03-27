class CreateSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :steps do |t|
      t.references :guide, null: false, foreign_key: true
      t.integer :step_order
      t.text :instruction_text
      t.string :screenshot_url

      t.timestamps
    end
  end
end
