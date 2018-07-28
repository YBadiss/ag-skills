module SkillsHelper
    def skills_as_options(skills)
        skills.map { |s| [s.name, s.id] }
    end
end
