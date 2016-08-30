class CreateSearchKeys < ActiveRecord::Migration
  def change
    create_table :search_keys do |t|
      t.string :name
      t.text :sqls
      t.string :params
      t.string :type
      t.string :comment

      t.timestamps
    end
  end
end
