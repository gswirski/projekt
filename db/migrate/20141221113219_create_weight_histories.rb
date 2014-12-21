class CreateWeightHistories < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.integer :user_id, null: false
      t.foreign_key :users, dependent: :delete
      t.decimal :weight, precision: 5, scale: 2, null: false
      t.datetime :created_at, null: false
    end

    add_index :weights, :user_id
  end
end
