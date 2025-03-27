class Parcours < ApplicationRecord
    has_many :parcours_guides, dependent: :destroy
    has_many :guides, through: :parcours_guides
  
    validates :title, presence: true
  end
  