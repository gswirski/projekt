class Meal < ActiveRecord::Base
  default_value_for :date do
    Time.now
  end

  def display_name
    I18n.l(date, format: :short)
  end
end
