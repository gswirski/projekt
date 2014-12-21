class CreateWeightHistories < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.integer :user_id
      t.foreign_key :users
      t.decimal :weight, precision: 5, scale: 2
      t.datetime :created_at
    end

    add_index :weights, :user_id
  end
end
