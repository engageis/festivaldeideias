class GuestAbility
  include CanCan::Ability
  def initialize
    can :read, :all
  end
end

