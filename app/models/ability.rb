class Ability
  include CanCan::Ability

  def initialize(user)
    if !user
      can :read, Programmer, visibility: 'public'
      can :read, ResumeItem
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
      can :read, ResumeItem
      can [:create, :update, :destroy], ResumeItem do |resume_item|
        if user.programmer.present?
          user.programmer.id == resume_item.programmer_id
        else
          false
        end
      end
    end
  end
end
