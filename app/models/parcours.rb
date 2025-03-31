class Parcours < ApplicationRecord
    belongs_to :owner, class_name: "User"
    belongs_to :enterprise
    has_many :parcours_guides, dependent: :destroy
    has_many :guides, through: :parcours_guides
  
    validates :title, presence: true
    validates :description, presence: true
  end
  