class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is?(:admin)
      can :manage, :all
    end
    if user.is?(:user)
      cannot [:create, :update], User
      can :manage, User, id: user.id
    end
  end
end
