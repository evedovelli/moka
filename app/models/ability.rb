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
    can :home, User do |u|
      u == user
    end
    can :create, User
    can :update, User do |u|
      u == user
    end
    can :destroy, User do |u|
      u == user
    end


    # Options
    can :read, Option
    can :votes, Option do |option|
      (not option.battle.current?) || (option.battle.try(:user) == user) || (user.vote_for(option.battle))
    end


    # Battles
    can :create, Battle
    can :update, Battle do |battle|
      battle.try(:user) == user
    end
    can :destroy, Battle do |battle|
      battle.try(:user) == user
    end
    can :show, Battle do |battle|
      not battle.in_future?
    end
    can :show_results, Battle do |battle|
      (not battle.current?) || (battle.try(:user) == user) || (user.vote_for(battle))
    end


    # Votes
    can :create, Vote


    # Friendships
    can :create, Friendship
    can :destroy, Friendship do |friendship|
      friendship.try(:user) == user
    end

  end
end
