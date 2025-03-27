class Answer < ApplicationRecord
  belongs_to :question

  validates :text, presence: true
  # correct:boolean indique si la réponse est la bonne
end
