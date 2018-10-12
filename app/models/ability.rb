class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :access, :rails_admin
    else
      can :manage, Sneaker, :user_id => user.id
    end
  end
end
