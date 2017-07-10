class AddRatings < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :rating, :integer, default: 0
    add_index :questions, :rating

    add_column :answers, :rating, :integer, default: 0
    add_index :answers, :rating
  end
end
