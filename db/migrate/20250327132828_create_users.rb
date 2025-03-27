class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.integer :role
      t.references :enterprise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
