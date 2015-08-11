class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new # guest user

    # Administrators
    if user.has_role? :admin
      # users
      can :manage, User

      # Options
      can :manage, Option

      # Battles
      can :manage, Battle

      # Votes
      can :read, Vote
      can :create, Vote

      # Friendships
      can :manage, Friendship
    end

    # Other users
    # users
    can :read, User
    can :following, User
    can :followers, User
    can :home, User
    can :create, User do |u|
      u == user
    end
    can :update, User do |u|
      u == user
    end
    can :destroy, User do |u|
      u == user
    end

    # Options
    can :read, Option

    # Battles
    can :show, Battle do |e|
      not e.in_future?
    end
    can :create, Battle

    # Votes
    can :read, Vote
    can :create, Vote

    # Friendships
    can :create, Friendship
    can :destroy, Friendship do |friendship|
      friendship.try(:user) == user
    end
    can :index, Friendship

  end
end
