class Skill < ApplicationRecord
    has_many :children, class_name: "Skill", foreign_key: "parent_id"
    belongs_to :parent, class_name: "Skill", optional: true
    has_many :users

    validates :name, uniqueness: true
    validate :validate_parent_is_top_level

    scope :top_level, -> { where(parent: nil) }

    def validate_parent_is_top_level
        errors.add(:parent, 'must be a top level skill') unless parent&.parent.nil?
    end

    def all_users
        users + children.map(&:users).flatten
    end

    # This function is not needed anymore since we only allow for one level of depth in
    # the skill tree. I am leaving it as is only for the sake of the exercise.
    #
    # def descendants
    #     res = children.to_set
    #     children.each do |child|
    #         res.merge(child.descendants)
    #     end
    #     res
    # end
end
