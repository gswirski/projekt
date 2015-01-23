class Meal < ActiveRecord::Base
  belongs_to :user
  has_many :meal_products

  default_value_for :date do
    Time.now
  end

  def display_name
    I18n.l(date, format: :short)
  end
end
