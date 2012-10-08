class GuestAbility
  include CanCan::Ability
  def initialize
    can :read, :all
    can :search, Idea
    can :map, Idea
    can :pin_show, Idea
  end
end

