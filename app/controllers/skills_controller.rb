class SkillsController < ApplicationController
  def create
    @skill = Skill.new(skill_hash)
    @skill.save!

    redirect_to skills_url
  end

  def index
    @skills = Skill.all
  end

  private

  def skill_hash
    params.require(:skill).permit(:name, :parent_id)
  end
end
