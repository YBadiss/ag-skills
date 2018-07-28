class SummaryController < ApplicationController
    def index
        @summary = Skill.top_level.map do |skill|
            all_users = skill.all_users
            {
                id: skill.id,
                name: skill.name,
                users_count: all_users.size,
                points: all_users.map(&:points).sum
            }
        end
    end
end
