ActiveAdmin.register RecipeProduct do
  belongs_to :recipe
  menu false
  navigation_menu :default

  permit_params :product_id, :amount

  controller do
    def index
      redirect_to recipe_url(parent)
    end

    def show
      redirect_to recipe_url(parent)
    end

    def update_resource(o, attrs)
      RecipeProduct.update_all(*attrs, {recipe_id: o.recipe_id, product_id: o.product_id})
    end

    def destroy_resource(o)
      RecipeProduct.delete_all({recipe_id: o.recipe_id, product_id: o.product_id})
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
