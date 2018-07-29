class User < ApplicationRecord
  belongs_to :skill

  validates :points, presence: true
  validates :skill, presence: true

  def self.reset_to_test_state
    User.delete_all

    User.new(points: 100, skill: Skill.find_by(name: 'Football')).save!
    User.new(points: 200, skill: Skill.find_by(name: 'Football')).save!
    User.new(points: 100, skill: Skill.find_by(name: 'Foot')).save!
    User.new(points: 50, skill: Skill.find_by(name: 'Basketball')).save!
    User.new(points: 10, skill: Skill.find_by(name: 'Soccer')).save!
  end
end
