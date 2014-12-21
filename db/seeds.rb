# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
c = ActiveRecord::Base.connection
c.execute("insert into users (email, encrypted_password, sign_in_count) values ('marcin@example.com', '23543242f1ff214124', 17);")
c.execute("insert into vendors (name) values ('nestle');")
c.execute("insert into products (name, serving_size, serving_unit, calories, fat, carbs, proteins, vendor_id) values
           ('platki', 100, 'g', 100, 10, 20, 30, 1),
           ('soczek', 100, 'g', 100, 10, 20, 30, 1),
           ('mleko', 200, 'ml', 100, 24, 30, 21, 1)")
c.execute("insert into recipes (user_id, name) values (1, 'platki z mlekiem')")
c.execute("insert into recipe_products (recipe_id, product_id, amount) values (1, 1, 1), (1, 3, 2)")
c.execute("insert into meals (user_id, date) values (1, '2014-12-11')")
c.execute("insert into meal_recipes values (1, 1)")
c.execute("insert into meal_products values (1, 2, 3)")
