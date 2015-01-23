ActiveAdmin.register Meal do
  scope_to do
    current_user
  end

  permit_params :date

  index do
    selectable_column
    column :date do |m|
      link_to I18n.l(m.date, format: :short), meal_path(m)
    end
    actions
  end
end
