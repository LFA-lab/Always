class AddDetailsToSteps < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:steps, :screenshot_url)
      add_column :steps, :screenshot_url, :string
    end
    unless column_exists?(:steps, :visual_indicator)
      add_column :steps, :visual_indicator, :string
    end
    unless column_exists?(:steps, :description)
      add_column :steps, :description, :text
    end
    unless column_exists?(:steps, :additional_text)
      add_column :steps, :additional_text, :text
    end
  end
end
