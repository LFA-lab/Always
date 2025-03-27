class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :enterprise, optional: true
  has_many :guides, foreign_key: :owner_id, dependent: :destroy

  # Définition des rôles : 0 = admin, 1 = manager, 2 = user
  enum role: { admin: 0, manager: 1, user: 2 }

  validates :email, presence: true, uniqueness: true
end
