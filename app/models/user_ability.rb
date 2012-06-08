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
  end
end
