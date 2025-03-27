class Step < ApplicationRecord
  belongs_to :guide

  validates :instruction_text, presence: true
  validates :step_order, presence: true

  # step_order : permet de connaître l'ordre d'apparition de l'étape
end
