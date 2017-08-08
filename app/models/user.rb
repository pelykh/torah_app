class User < ApplicationRecord
  has_many :interests 
  has_many :subjects, through: :interests

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :lockable, :omniauthable
end
