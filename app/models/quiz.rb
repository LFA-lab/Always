class Quiz < ApplicationRecord
  belongs_to :guide

  has_many :questions, dependent: :destroy
end
