class Enterprise < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :guides, dependent: :destroy
    has_many :parcours, class_name: "Parcours", dependent: :destroy
  
    validates :name, presence: true
  end
  