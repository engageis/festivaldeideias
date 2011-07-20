class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.sites.size > 0

      can :manage, Site do |site|
        user.sites.include?(site)
      end

      can :manage, Category do |category|
        user.sites.include? category.site
      end
      cannot :manage, Category

      can :manage, Idea do |idea|
        user.sites.include?(idea.site)
      end

      can :manage, User do |u|
        user.sites.include?(u.site)
      end

    else
      can :read, :all

      can :create, Idea
      can :manage, User, :id => user.id
      can :manage, Idea, :user_id => user.id
    end

    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
