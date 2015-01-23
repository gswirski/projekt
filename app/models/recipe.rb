class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_products
  #has_many :products, through: :recipe_products
end
