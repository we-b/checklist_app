class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.text :text
      t.integer :checklist_id
      t.integer :group_id
      t.boolean :checked
      t.timestamps
    end
  end
end
