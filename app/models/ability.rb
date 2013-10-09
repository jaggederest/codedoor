class Ability
  include CanCan::Ability

  def initialize(user)
    if !user
      can :read, Programmer, visibility: 'public'
      can :read, [ResumeItem, EducationItem, PortfolioItem]
    else
      can :manage, User, id: user.id
      can :manage, PaymentInfo, user_id: user.id
      can :read, Programmer do |programmer|
        if programmer.visible_to_others?
          true
        else
          programmer.user_id == user.id
        end
      end
      can :read, Client
      can [:create, :update, :destroy], [Programmer, Client], user_id: user.id
      can :read, [ResumeItem, EducationItem, PortfolioItem]
      can [:create, :update, :destroy], [ResumeItem, EducationItem, PortfolioItem] do |item|
        if user.programmer.present?
          user.programmer.id == item.programmer_id
        else
          false
        end
      end
    end
  end
end
