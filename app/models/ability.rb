class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Order if user.is?(:admin)
    can :manage, User if user.is?(:user)
    can :manage, Offer if user.is?(:admin)
    if !user.is?(:admin)
      cannot [:create, :update], User
    end
  end
end
