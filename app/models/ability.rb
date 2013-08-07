class Ability
  include CanCan::Ability

  def initialize(user)
    if !user
      can :read, Programmer
    else
      can :manage, User, id: user.id
      can :read, Programmer
      can [:create, :update, :destroy], Programmer, user_id: user.id
    end
  end
end
