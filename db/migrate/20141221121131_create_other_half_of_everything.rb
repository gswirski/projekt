class CreateOtherHalfOfEverything < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :user_id, null: false
      t.foreign_key :users, dependent: :delete
      t.datetime :date, null: false
    end

    create_table :recipes do |t|
      t.integer :user_id, null: false
      t.foreign_key :users, dependent: :delete
      t.string :name, null: false
    end

    create_table :recipe_products, id: false do |t|
      t.integer :recipe_id, null: false
      t.foreign_key :recipes, dependent: :delete
      t.integer :product_id, null: false
      t.foreign_key :products, dependent: :delete
      t.decimal :amount, precision: 10, scale: 2, default: 1, null: false
    end

    create_table :meal_products, id: false do |t|
      t.integer :meal_id, null: false
      t.foreign_key :meals, dependent: :delete
      t.integer :product_id, null: false
      t.foreign_key :products, dependent: :delete
      t.decimal :amount, precision: 10, scale: 2, default: 1, null: false
    end

    create_table :meal_recipes, id: false do |t|
      t.integer :meal_id, null: false
      t.foreign_key :meals, dependent: :delete
      t.integer :recipe_id, null: false
      t.foreign_key :recipes, dependent: :delete
    end

    add_index :meals, :user_id
    add_index :recipes, :user_id
    add_index :recipe_products, :recipe_id
    add_index :recipe_products, :product_id
    add_index :meal_products, :meal_id
    add_index :meal_products, :product_id
    add_index :meal_recipes, :meal_id
    add_index :meal_recipes, :recipe_id
  end
end
