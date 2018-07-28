module SkillsHelper
    def selectable_skills
        Skill.all.map { |s| [s.name, s.id] }
    end
end
