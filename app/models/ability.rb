class Ability
  include CanCan::Ability

  def initialize(user)
    if !user
      can :read, Programmer, visibility: 'public'
    else
      can :manage, User, id: user.id
      can :read, Programmer do |programmer|
        if programmer.private?
          programmer.user_id == user.id
        else
          true
        end
      end
      can [:create, :update, :destroy], Programmer, user_id: user.id
    end
  end
end
