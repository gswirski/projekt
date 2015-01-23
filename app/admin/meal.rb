ActiveAdmin.register Meal do
  scope_to do
    current_user
  end

  permit_params :date
  filter :date

  index do
    selectable_column
    column :date do |m|
      link_to I18n.l(m.date, format: :short), meal_path(m)
    end
    column :products do |m| m.details.products end
    column :calories do |m| m.details.calories end
    column :fat do |m| m.details.fat end
    column :carbs do |m| m.details.carbs end
    column :proteins do |m| m.details.proteins end
    actions
  end

  show do
    attributes_table do
      row :products do meal.details.products end
      row :calories do meal.details.calories end
      row :fat do meal.details.fat end
      row :carbs do meal.details.carbs end
      row :proteins do meal.details.proteins end
    end

    panel "Recipes" do
      table_for meal.recipes do
        column :recipe do |mr|
          link_to mr.name, recipe_path(mr)
        end
        column :products do |mr| mr.details.products end
        column :calories do |mr| mr.details.calories end
        column :fat do |mr| mr.details.fat end
        column :carbs do |mr| mr.details.carbs end
        column :proteins do |mr| mr.details.proteins end
        column :actions do |mr|
          link_to("Edit", edit_meal_meal_recipe_path(meal_id: meal.id, id: mr.id)) + " " +
          link_to("Delete", meal_meal_recipe_path(meal_id: meal.id, id: mr.id), method: :delete, confirm: "Are you sure?")
        end
      end
      div do
        link_to "Add recipe", new_meal_meal_recipe_path(meal), class: "button"
      end
    end

    panel "Additional products" do
      table_for meal.meal_products do
        column :product
        column :serving_size do |mp| "#{mp.details.serving_size} #{mp.details.serving_unit}" end
        column :calories do |mp| mp.details.calories end
        column :fat do |mp| mp.details.fat end
        column :carbs do |mp| mp.details.carbs end
        column :proteins do |mp| mp.details.proteins end
        column :actions do |mp|
          link_to("Edit", edit_meal_meal_product_path(meal_id: meal.id, id: mp.product_id)) + " " +
          link_to("Delete", meal_meal_product_path(meal_id: meal.id, id: mp.product_id), method: :delete, confirm: "Are you sure?")
        end
      end
      div do
        link_to "Add product", new_meal_meal_product_path(meal), class: "button"
      end
    end
  end
end
