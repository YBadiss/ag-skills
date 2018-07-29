class Skill < ApplicationRecord
    has_many :children, class_name: "Skill", foreign_key: "parent_id"
    belongs_to :parent, class_name: "Skill", optional: true
    has_many :users

    validates :name, uniqueness: true
    validate :validate_parent_is_top_level

    scope :top_level, -> { where(parent: nil) }

    # Validates that the depth of the skill tree is at most 2 (parent + children)
    # In a case with a deeper tree, this check would also help prevent circularity
    def validate_parent_is_top_level
        errors.add(:parent, 'must be a top level skill') unless parent&.parent.nil?
    end

    def all_users
        users + children.map(&:users).flatten
    end

    def self.rails_summary
      res = Skill.top_level.map do |skill|
        all_users = skill.all_users
        {
            id: skill.id,
            name: skill.name,
            users_count: all_users.size,
            points: all_users.map(&:points).sum
        }
      end
      res.map(&:with_indifferent_access)
    end

    def self.sql_summary
      res = ActiveRecord::Base.connection.execute <<-SQL
            SELECT COALESCE(s1.id, s.id) AS id, COALESCE(s1.name, s.name) AS name, COUNT(u.id) AS users_count,
                   COALESCE(SUM(u.points), 0) AS points
            FROM skills s
            LEFT JOIN users u ON u.skill_id = s.id
            LEFT JOIN skills s1 ON s1.id = s.parent_id
            GROUP BY COALESCE(s1.id, s.id);
      SQL
      res.map { |h| h.with_indifferent_access.slice(:id, :name, :users_count, :points) }
    end

    # This function is not needed anymore since we only allow for a simple parent/child relation (no deeper links) in
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
