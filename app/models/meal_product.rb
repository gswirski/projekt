class MealProduct < ActiveRecord::Base
  # ugly hack to make ActiveAdmin work
  self.primary_key = "product_id"

  belongs_to :meal
  belongs_to :product

  def details
    @details ||= MealProductDetail.where(meal_id: meal_id, product_id: product_id).first
  end
end
