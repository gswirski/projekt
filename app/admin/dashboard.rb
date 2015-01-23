ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    panel "Weight History" do
      para do
        current_user.weights.map do |w|
          "#{w.weight} (#{w.created_at.strftime("%b %d")})"
        end.join(", ")
      end
      para do
        link_to "Add Weight", new_weight_path, class: "button"
      end
    end

    columns do
      column do
        panel "Recent Meals" do
          table_for Meal.where(user_id: current_user.id).order("id desc").limit(5) do
            column :name do |m|
              link_to(I18n.l(m.date, format: :short), meal_path(m))
            end
            column :products do |m| m.details.products end
            column :calories do |m| m.details.calories end
            column :fat      do |m| m.details.fat end
            column :carbs    do |m| m.details.carbs end
            column :proteins do |m| m.details.proteins end
          end
          para do
            link_to "Add Meal", new_meal_path, class: "button"
          end
        end
      end

      column do
        panel "Recent Recipes" do
          table_for Recipe.where(user_id: current_user.id).order("id desc").limit(5) do
            column :name do |r|
              link_to(r.name, recipe_path(r))
            end
            column :products do |r| r.details.products end
            column :calories do |r| r.details.calories end
            column :fat      do |r| r.details.fat end
            column :carbs    do |r| r.details.carbs end
            column :proteins do |r| r.details.proteins end
          end
          para do
            link_to "Add Recipe", new_recipe_path, class: "button"
          end
        end
      end
    end
  end
end
