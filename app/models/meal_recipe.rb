class MealRecipe < ActiveRecord::Base
  # ugly hack to make ActiveAdmin work
  self.primary_key = "recipe_id"

  belongs_to :meal
  belongs_to :recipe
end
