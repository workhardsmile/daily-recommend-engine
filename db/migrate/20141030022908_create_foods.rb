class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.string :price
      t.integer :recommend_time
      t.string :food_url
      t.string :image_url
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
