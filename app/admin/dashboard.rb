ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Meals" do
          ul do
            Meal.where(user_id: current_user.id).order("id desc").limit(5).map do |meal|
              li link_to(I18n.l(meal.date, format: :short), meal_path(meal))
            end
          end
          para do
            link_to "Add Meal", new_meal_path, class: "button"
          end
        end
      end

      column do
        panel "Recent Recipes" do
          ul do
            Recipe.where(user_id: current_user.id).order("id desc").limit(5).map do |recipe|
              li link_to(recipe.name, recipe_path(recipe))
            end
          end
          para do
            link_to "Add Recipe", new_recipe_path, class: "button"
          end
        end
      end
    end
  end
end
