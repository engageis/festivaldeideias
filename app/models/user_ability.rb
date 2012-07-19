class UserAbility
  include CanCan::Ability

  def initialize(user)

    can :read, :all
    can :cocreate, Idea
    can :create, Idea
    can :create, Message
    can :colaborate, Idea do |idea|
      idea.user != user
    end
    can :manage, Idea, :user => user
    can :notifications, User
    can :update_notification, User
    can :manage, User, :id => user.id

  end
end
