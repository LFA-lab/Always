class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.references :guide, null: false, foreign_key: true

      t.timestamps
    end
  end
end
