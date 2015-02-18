class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is?(:user)
      can :manage, User, id: user.id
    end
    if user.is?(:admin)
      can :manage, :all
    end
  end
end
