class User < ActiveRecord::Base
  has_many :recipes
  has_many :meals
  has_many :weights

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    email
  end
end
