class Guide < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :enterprise, optional: true

  enum :visibility, { private_guide: 0, public_guide: 1 }, default: :private_guide

  has_many :steps, dependent: :destroy
  has_one :quiz, dependent: :destroy
  has_many :guide_feedbacks, dependent: :destroy
  has_many :parcours_guides, dependent: :destroy
  has_many :parcours, through: :parcours_guides

  has_many_attached :screenshots

  validates :title, presence: true
  validates :owner, presence: true
  validates :enterprise, presence: true, if: -> { owner.manager? }
  validates :content, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]) }

  # Scope pour les guides publiés
  scope :published, -> { where(visibility: :public_guide) }

  # Si vous utilisez FriendlyId, vous pourrez décommenter ces lignes :
  # extend FriendlyId
  # friendly_id :title, use: :slugged

  # Méthode pour créer un guide à partir des données de l'extension
  def self.create_from_extension(data, user)
    guide = new(
      title: data[:title],
      description: data[:description],
      owner: user,
      enterprise: user.enterprise,
      visibility: :private_guide
    )

    if guide.save
      # Créer les étapes
      data[:steps].each_with_index do |step_data, index|
        guide.steps.create!(
          instruction_text: step_data[:description],
          step_order: index + 1,
          screenshot_url: step_data[:screenshot],
          visual_indicator: step_data[:type]
        )
      end
    end

    guide
  end
end
