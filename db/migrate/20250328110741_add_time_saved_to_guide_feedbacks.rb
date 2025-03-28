class AddTimeSavedToGuideFeedbacks < ActiveRecord::Migration[8.0]
  def change
    add_column :guide_feedbacks, :time_saved, :integer, default: 0
  end
end
