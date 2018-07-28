class User < ApplicationRecord
    belongs_to :skill

    validates :points, presence: true
    validates :skill, presence: true
end
