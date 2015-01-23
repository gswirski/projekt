class RecipeProduct < ActiveRecord::Base
  # ugly hack to make ActiveAdmin work
  self.primary_key = "product_id"

  belongs_to :recipe
  belongs_to :product

  def details
    @details ||= RecipeProductDetail.where(recipe_id: recipe_id, product_id: product_id).first
  end
end
