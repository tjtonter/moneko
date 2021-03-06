class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is?(:admin)
      can :manage, :all
    end
    if user.is?(:user)
      can :manage, User, id: user.id
      can :read, Order
    end
  end
end
