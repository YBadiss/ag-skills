class SummaryController < ApplicationController
    def index
        @summaries = {
            'SQL Summary': sql_summary,
            'Rails Summary': rails_summary
        }
    end

    private

    def rails_summary
        Skill.top_level.map do |skill|
            all_users = skill.all_users
            {
                id: skill.id,
                name: skill.name,
                users_count: all_users.size,
                points: all_users.map(&:points).sum
            }
        end
    end

    def sql_summary
        res = ActiveRecord::Base.connection.execute <<-SQL
            SELECT COALESCE(s1.id, s.id) AS id, COALESCE(s1.name, s.name) AS name,
                   COUNT(u.id) AS users_count, COALESCE(SUM(u.points), 0) AS points
            FROM skills s
            LEFT JOIN users u ON s.id = u.skill_id
            LEFT JOIN skills s1 ON s1.id = s.parent_id
            GROUP BY COALESCE(s1.id, s.id);
        SQL
        res.map(&:with_indifferent_access)
    end
end
