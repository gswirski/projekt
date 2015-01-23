class DropRecipesWithNutrition < ActiveRecord::Migration
  def change
    sql = "DROP VIEW recipes_with_nutrition CASCADE;"
    ActiveRecord::Base.connection.execute(sql)
  end
end
