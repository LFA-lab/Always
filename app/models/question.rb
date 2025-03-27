class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  validates :title, presence: true
end
