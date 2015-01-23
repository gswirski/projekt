class AddDefaultTimestampToMeal < ActiveRecord::Migration
  def up
    sql = "ALTER TABLE meals ALTER COLUMN date SET DEFAULT NOW();"
    ActiveRecord::Base.connection.execute(sql)
  end
end
