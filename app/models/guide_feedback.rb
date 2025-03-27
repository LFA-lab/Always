class GuideFeedback < ApplicationRecord
  belongs_to :guide
  belongs_to :user, optional: true

  # Champs distincts : "stars" pour les étoiles, "comment" pour le texte
  validates :stars, presence: true, numericality: { only_integer: true, in: 1..5 }
  validates :comment, presence: true

  # Par exemple : 1..5 pour le champ "stars"
end
