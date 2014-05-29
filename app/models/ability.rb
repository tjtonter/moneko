class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Order if user.is?(:admin)
    can :manage, Offer if user.is?(:admin)
    can :manage, User if user.is?(:admin)
    can :manage, User if user.is?(:user)
    if !user.is?(:admin)
      cannot [:create, :update], User
      cannot :manage, Offer
    end
  end
end
