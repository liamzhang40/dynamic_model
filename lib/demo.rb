require_relative 'sql_object'

class User < SQLObject

  has_many :teammemberships,
    class_name: 'TeamMembership',
    foreign_id: :member_id

  finalize!
end

class Team < SQLObject

  has_many :teammemberships,
    class_name: 'TeamMembership',
    foreign_id: :team_id

  finalize!
end

class TeamMembership < SQLObject

  belongs_to :team

  belongs_to :member,
    class_name: 'User',
    foreign_id: :member_id

  finalize!
end
