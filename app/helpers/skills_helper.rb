module SkillsHelper
    def valid_parent_skills
        [[nil, nil]] + Skill.all.map { |s| [s.name, s.id] }
    end
end
