class Step < ApplicationRecord
  belongs_to :guide

  validates :instruction_text, presence: true
  validates :step_order, presence: true
  validates :screenshot_url, presence: true
  validates :visual_indicator, presence: true
  validates :description, presence: true
end
