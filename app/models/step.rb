class Step < ApplicationRecord
  belongs_to :guide
  has_one_attached :screenshot

  validates :instruction_text, presence: true
  validates :step_order, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :visual_indicator, presence: true
  validates :element_selector, presence: true
  validates :element_type, presence: true
  validates :timestamp, presence: true

  before_validation :set_defaults

  scope :ordered, -> { order(step_order: :asc) }

  def self.visual_indicators
    %w[click hover scroll type select highlight]
  end

  def self.element_types
    %w[button link input select textarea div span p h1 h2 h3 h4 h5 h6]
  end

  def screenshot_url
    if screenshot.attached?
      Rails.application.routes.url_helpers.url_for(screenshot)
    else
      nil
    end
  end

  private

  def set_defaults
    return if step_order.present?
    self.step_order = guide.steps.count + 1
    self.visual_indicator ||= 'click'
    self.element_type ||= 'button'
  end
end
