class AddRecipeDetailsView < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE VIEW recipe_details AS
      SELECT r.id, r.name, COUNT(p.product_id)
      FROM recipes r
      LEFT JOIN recipe_products p ON r.id = p.recipe_id
      GROUP BY r.id, r.name;
      SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    sql = <<-SQL
      DROP VIEW recipe_details;
      SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
