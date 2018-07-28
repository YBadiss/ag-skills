class CreateSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :skills, :name, unique: true
    add_foreign_key :skills, :skills, column_name: :parent_id
  end
end
