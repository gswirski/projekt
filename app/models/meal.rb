class Meal < ActiveRecord::Base
  belongs_to :user
  has_many :meal_products
  has_many :meal_recipes
  has_many :recipes, through: :meal_recipes

  has_one :details, class_name: MealDetail,
                    foreign_key: 'id'

  default_scope { includes(:details) }

  default_value_for :date do
    Time.now
  end

  def display_name
    I18n.l(date, format: :short)
  end
end
