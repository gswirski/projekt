class AddMealDetailView < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE VIEW meal_details AS
      SELECT
        m.id,
        m.date,
        SUM(u.products) as products,
        SUM(u.calories) as calories,
        SUM(u.fat) as fat,
        SUM(u.carbs) as carbs,
        SUM(u.proteins) as proteins
      FROM meals m
      LEFT JOIN (
        SELECT
          mr.meal_id,
          r.products,
          r.calories,
          r.fat,
          r.carbs,
          r.proteins
        FROM recipe_details r
        JOIN meal_recipes mr ON r.id = mr.recipe_id
      UNION ALL
        SELECT
          mp.meal_id,
          COUNT(mp.product_id) as products,
          SUM(mp.calories) as calories,
          SUM(mp.fat) as fat,
          SUM(mp.carbs) as carbs,
          SUM(mp.proteins) as proteins
        FROM meal_product_details mp
        GROUP BY mp.meal_id
      ) u ON m.id = u.meal_id
      GROUP BY m.id, m.date;
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    sql = "DROP VIEW meal_details;"
    ActiveRecord::Base.connection.execute(sql)
  end
end
