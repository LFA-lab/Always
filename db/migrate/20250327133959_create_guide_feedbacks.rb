class CreateGuideFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :guide_feedbacks do |t|
      t.references :guide, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :stars
      t.text :comment

      t.timestamps
    end
  end
end
