ActiveAdmin.register RecipeProduct do
  belongs_to :recipe
  menu false
  navigation_menu :default

  permit_params :product_id, :amount

  controller do
    def index
      redirect_to admin_recipe_url(parent)
    end

    def show
      redirect_to admin_recipe_url(parent)
    end
  end

  form do |f|
    f.inputs do
      f.input :product
      f.input :amount
    end
    f.actions
  end
end
