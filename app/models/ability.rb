class Ability
  include CanCan::Ability

  def initialize(user)
    if !user
      can :read, Contractor
    else
      can :manage, User, user_id: user.id
      can :read, Contractor
      can [:create, :update, :destroy], Contractor, user_id: user.id
    end
  end
end
