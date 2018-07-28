class Skill < ApplicationRecord
    has_many :children, class_name: "Skill", foreign_key: "parent_id"
    belongs_to :parent, class_name: "Skill", optional: true
    has_many :users

    validates :name, uniqueness: true

    scope :top_level, -> { where(parent: nil) }

    def descendants
        res = children.to_set
        children.each do |child|
            res.merge(child.descendants)
        end
        res
    end

    def all_users
        users + descendants.map(&:users).flatten
    end
end
