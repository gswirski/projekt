class AddForeignConstraints < ActiveRecord::Migration
  def up
    sql = <<-SQL
      alter table meal_products
      drop constraint meal_products_product_id_fk,
      add constraint meal_products_product_id_fk foreign key (product_id) references products (id) on delete restrict;
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<-SQL
      alter table recipe_products
      drop constraint recipe_products_product_id_fk,
      add constraint recipe_products_product_id_fk foreign key (product_id) references products (id) on delete restrict;
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<-SQL
      alter table meal_recipes
      drop constraint meal_recipes_recipe_id_fk,
      add constraint meal_recipes_recipe_id_fk foreign key (recipe_id) references recipes (id) on delete restrict;
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
