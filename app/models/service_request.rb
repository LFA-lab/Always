class ServiceRequest < ApplicationRecord
  belongs_to :user

  validates :description, presence: true
  validates :status, presence: true
end
