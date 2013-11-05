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
      can_see_for_jobs(user)
    end
  end

  protected

  def can_see_for_jobs(user)
    can [:create], Job do |job|
      # Right now, you can hire yourself, although it is not exposed in the UI.  Why not?
      user.client.present?
    end
    can [:read, :update, :destroy], Job do |job|
      can_see = false
      can_see = true if user.client.present? && job.client_id == user.client.id
      can_see = true if user.programmer.present? && job.programmer_id == user.programmer.id
      can_see
    end
    can :update_as_client, Job do |job|
      user.client.present? && job.client_id == user.client.id
    end
    can :update_as_programmer, Job do |job|
      user.programmer.present? && job.programmer_id == user.programmer.id
    end
  end
end
