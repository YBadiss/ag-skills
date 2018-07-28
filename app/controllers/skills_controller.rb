class SkillsController < ApplicationController
    def create
        @skill = Skill.new(skill_hash)
        @skill.save!

        redirect_to @skill
    end

    def show
        @skill = Skill.find(params[:id])
    end

    def index
        @skills = Skill.all
    end

    private

    def skill_hash
        params.require(:skill).permit(:name, :parent_id)
    end
end
