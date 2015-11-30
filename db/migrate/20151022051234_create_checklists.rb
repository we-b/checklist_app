class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.integer :frequency
      t.integer :date
      t.integer :wday
      t.string :maker
      t.string :image
      t.boolean :done, default: false
      t.integer :todayflag, dafault: 0
      t.timestamps
    end
  end
end
