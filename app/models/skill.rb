class Skill < ApplicationRecord
    has_many :children, class_name: "Skill", foreign_key: "parent_id"
    belongs_to :parent, class_name: "Skill", optional: true
end
