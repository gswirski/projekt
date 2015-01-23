class AddRecipeProductDetailView < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE VIEW recipe_product_details AS
      SELECT
        r.recipe_id,
        p.vendor_id,
        r.product_id,
        r.amount,
        p.name,
        p.serving_size * r.amount as serving_size,
        p.serving_unit,
        p.calories * r.amount as calories,
        p.fat * r.amount as fat,
        p.carbs * r.amount as carbs,
        p.proteins * r.amount as proteins
      FROM recipe_products r
      JOIN products p on p.id = r.product_id;
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    sql = "DROP VIEW recipe_product_details;"
    ActiveRecord::Base.connection.execute(sql)
  end
end
