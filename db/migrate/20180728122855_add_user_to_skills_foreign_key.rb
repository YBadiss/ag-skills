class AddUserToSkillsForeignKey < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :skill, index: true
  end
end
