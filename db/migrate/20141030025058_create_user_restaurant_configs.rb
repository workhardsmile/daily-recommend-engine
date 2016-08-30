class CreateUserRestaurantConfigs < ActiveRecord::Migration
  def change
    create_table :user_restaurant_configs do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :score
      t.text :commet

      t.timestamps
    end
  end
end
