class AddViews < ActiveRecord::Migration
  def change
    execute <<-sql
    create or replace view recipes_with_nutrition (id, user_id, name, calories, fat, carbs, proteins) as
      select recipes.id, recipes.user_id, recipes.name, coalesce(sum(amount * calories), 0), coalesce(sum(amount * fat), 0),
             coalesce(sum(amount * carbs), 0), coalesce(sum(amount * proteins), 0)
      from recipes
      left join recipe_products on recipes.id = recipe_products.recipe_id
      left join products on products.id = recipe_products.product_id
      group by recipes.id;
    sql
  end
end
