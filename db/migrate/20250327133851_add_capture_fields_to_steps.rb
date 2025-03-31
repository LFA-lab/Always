class AddCaptureFieldsToSteps < ActiveRecord::Migration[7.1]
  def change
    add_column :steps, :element_selector, :string
    add_column :steps, :element_type, :string
    add_column :steps, :element_text, :text
    add_column :steps, :coordinates, :json
    add_column :steps, :scroll_position, :json
    add_column :steps, :timestamp, :datetime
    add_column :steps, :browser_info, :json
    add_column :steps, :device_info, :json

    add_index :steps, :element_type
    add_index :steps, :timestamp
  end
end 