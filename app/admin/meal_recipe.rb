ActiveAdmin.register MealRecipe do
  belongs_to :meal
  menu false
  navigation_menu :default

  permit_params :recipe_id

  controller do
    def index
      redirect_to meal_url(parent)
    end

    def show
      redirect_to meal_url(parent)
    end

    def update_resource(o, attrs)
      MealRecipe.update_all(*attrs, {meal_id: o.meal_id, recipe_id: o.recipe_id})
    end

    def destroy_resource(o)
      MealRecipe.delete_all({meal_id: o.meal_id, recipe_id: o.recipe_id})
    end
  end

  form do |f|
    f.inputs do
      f.input :recipe
    end
    f.actions
  end
end
