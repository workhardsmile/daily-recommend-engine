class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :type
      t.string :scores
      t.string :score_times
      t.string :location
      t.string :address
      t.string :telephone
      t.string :price
      t.string :level
      t.string :shop_url
      t.string :image_url
      t.text :comment

      t.timestamps
    end
  end
end
