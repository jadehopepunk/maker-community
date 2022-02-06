class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # , :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :user_memberships
end
