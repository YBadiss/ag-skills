class SummaryController < ApplicationController
  def index
    @summaries = {
        'SQL Summary': Skill.sql_summary,
        'Rails Summary': Skill.rails_summary
    }
  end

  def reset_to_test_state
    Skill.reset_to_test_state
    User.reset_to_test_state

    redirect_to root_path
  end
end
