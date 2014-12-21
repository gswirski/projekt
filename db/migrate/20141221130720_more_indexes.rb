class MoreIndexes < ActiveRecord::Migration
  def change
    add_index :vendors, :name, unique: true
    add_index :products, :name
  end
end
