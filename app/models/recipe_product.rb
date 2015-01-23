class RecipeProduct < ActiveRecord::Base
  # ugly hack to make ActiveAdmin work
  self.primary_key = "product_id"

  belongs_to :recipe
  belongs_to :product
end
