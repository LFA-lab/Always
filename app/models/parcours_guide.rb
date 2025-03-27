class ParcoursGuide < ApplicationRecord
  belongs_to :parcours
  belongs_to :guide

  validates :order_in_parcours, presence: true, numericality: { only_integer: true }
end
