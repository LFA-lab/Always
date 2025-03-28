class Guide < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :enterprise, optional: true

  enum :visibility, { private_guide: 0, public_guide: 1 }, default: :private_guide

  has_many :steps, dependent: :destroy
  has_one :quiz, dependent: :destroy
  has_many :guide_feedbacks, dependent: :destroy

  validates :title, presence: true

  # Scope pour les guides publiés
  scope :published, -> { where(visibility: :public_guide) }

  # Si vous utilisez FriendlyId, vous pourrez décommenter ces lignes :
  # extend FriendlyId
  # friendly_id :title, use: :slugged
end
