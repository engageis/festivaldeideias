class GuestAbility
  include CanCan::Ability
  def initialize
    can :read, :all
    can :search, Idea
  end
end

