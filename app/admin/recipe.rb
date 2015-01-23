ActiveAdmin.register Recipe do
  filter :name
  permit_params :name

  scope_to do
    current_user
  end

  show do
    panel "Products" do
      table_for recipe.recipe_products do
        column :product
        column :serving do |rp|
          p = rp.product
          "#{p.serving_size * rp.amount} #{p.serving_unit}"
        end
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
