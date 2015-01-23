class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_products

  has_one :details, class_name: RecipeDetail,
                    foreign_key: 'id'

  default_scope { includes(:details) }
end
