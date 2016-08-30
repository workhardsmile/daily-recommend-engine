class CreateFrequentSets < ActiveRecord::Migration
  def change
    create_table :frequent_sets do |t|
      t.string :name
      t.integer :surport_level
      t.string :last_sn
      t.string :type
      t.string :date_label

      t.timestamps
    end
  end
end
