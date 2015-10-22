class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.integer :frequency
      t.integer :date
      t.integer :days
      t.string :maker
      t.string :image
      t.boolean :done
      t.integer :todayflag
      t.timestamps
    end
  end
end