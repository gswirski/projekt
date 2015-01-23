ActiveAdmin.register Recipe do
  filter :name
  permit_params :name

  scope_to do
    current_user
  end

  index do
    selectable_column
    id_column
    column :name
    column :products do |r| r.details.products end
    column :calories do |r| r.details.calories end
    column :fat do |r| r.details.fat end
    column :carbs do |r| r.details.carbs end
    column :proteins do |r| r.details.proteins end
    actions
  end

  show do
    attributes_table do
      row :products do recipe.details.products end
      row :calories do recipe.details.calories end
      row :fat do recipe.details.fat end
      row :carbs do recipe.details.carbs end
      row :proteins do recipe.details.proteins end
    end

    panel "Products" do
      table_for recipe.recipe_products do
        column :product
        column :serving_size do |rp| "#{rp.details.serving_size} #{rp.details.serving_unit}" end
        column :calories do |rp| rp.details.calories end
        column :fat do |rp| rp.details.fat end
        column :carbs do |rp| rp.details.carbs end
        column :proteins do |rp| rp.details.proteins end
        column :actions do |rp|
          link_to("Edit", edit_recipe_recipe_product_path(recipe_id: recipe.id, id: rp.product_id)) + " " +
          link_to("Delete", recipe_recipe_product_path(recipe_id: recipe.id, id: rp.product_id), method: :delete, confirm: "Are you sure?")
        end
      end
      div do
        link_to "Add product", new_recipe_recipe_product_path(recipe), class: "button"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
