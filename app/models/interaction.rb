class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :guide, optional: true

  validates :action_type, presence: true
  validates :element_type, presence: true
  validates :element_selector, presence: true
  validates :timestamp, presence: true

  serialize :metadata, JSON

  scope :recent, -> { order(created_at: :desc) }
  scope :by_guide, ->(guide_id) { where(guide_id: guide_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  def self.action_types
    %w[click hover scroll type select]
  end

  def self.element_types
    %w[button link input select textarea div span p h1 h2 h3 h4 h5 h6]
  end
end 