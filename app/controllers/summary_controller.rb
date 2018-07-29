class SummaryController < ApplicationController
    def index
        @summaries = {
            'SQL Summary': Skill.sql_summary,
            'Rails Summary': Skill.rails_summary
        }
    end
end
