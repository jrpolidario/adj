# Currently "user" can only be admins, just solely to manage game resources such
# as cards and categories
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: true
end
