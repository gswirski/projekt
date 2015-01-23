ActiveAdmin.register MealProduct do
  belongs_to :meal
  menu false
  navigation_menu :default

  permit_params :product_id, :amount

  controller do
    def index
      redirect_to meal_url(parent)
    end

    def show
      redirect_to meal_url(parent)
    end

    def update_resource(o, attrs)
      MealProduct.update_all(*attrs, {meal_id: o.meal_id, product_id: o.product_id})
    end

    def destroy_resource(o)
      MealProduct.delete_all({meal_id: o.meal_id, product_id: o.product_id})
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
