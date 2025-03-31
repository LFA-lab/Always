class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :enterprise, optional: true
  has_many :guides, foreign_key: :owner_id, dependent: :destroy

  # Définition des rôles
  enum :role, { admin: 0, manager: 1, user: 2 }, default: :user

  accepts_nested_attributes_for :enterprise

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :service, presence: true
  validates :enterprise_id, presence: true, unless: :manager?

  def generate_jwt
    JWT.encode(
      { user_id: id, exp: 24.hours.from_now.to_i },
      Rails.application.credentials.secret_key_base
    )
  end
end
