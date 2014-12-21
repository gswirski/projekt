class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :serving_size, precision: 10, scale: 2, null: false
      t.string :serving_unit, null: false
      t.decimal :calories, precision: 10, scale: 2, null: false
      t.decimal :fat, precision: 10, scale: 2, null: false
      t.decimal :carbs, precision: 10, scale: 2, null: false
      t.decimal :proteins, precision: 10, scale: 2, null: false

      t.integer :vendor_id, null: false
      t.foreign_key :vendors
    end
    add_index :products, :vendor_id
  end
end
