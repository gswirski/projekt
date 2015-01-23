class AddRecipeDetailView < ActiveRecord::Migration
  def up
    down

    sql = <<-SQL
      CREATE VIEW recipe_details AS
      SELECT
        r.id,
        r.name,
        COUNT(p.product_id) as products,
        SUM(p.calories) as calories,
        SUM(p.fat) as fat,
        SUM(p.carbs) as carbs,
        SUM(p.proteins) as proteins
      FROM recipes r
      LEFT JOIN recipe_product_details p ON r.id = p.recipe_id
      GROUP BY r.id, r.name;
      SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    sql = "DROP VIEW recipe_details;"
    ActiveRecord::Base.connection.execute(sql)
  end
end
