class AddCompositePrimaryKeys < ActiveRecord::Migration
  def up
    sql = <<-SQL
      ALTER TABLE ONLY recipe_products
        ADD CONSTRAINT recipe_products_pkey PRIMARY KEY (recipe_id, product_id);
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<-SQL
      ALTER TABLE ONLY meal_products
        ADD CONSTRAINT meal_products_pkey PRIMARY KEY (meal_id, product_id);
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<-SQL
      ALTER TABLE ONLY meal_recipes
        ADD CONSTRAINT meal_recipes_pkey PRIMARY KEY (meal_id, recipe_id);
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
