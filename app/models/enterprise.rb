class Enterprise < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :guides, dependent: :destroy
  
    validates :name, presence: true
  end
  