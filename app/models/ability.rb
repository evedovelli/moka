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


    ################
    # Administrators

    if user.has_role? :admin
      # Users
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


      # Notifications
      can :manage, Notification


      # EmailSettings
      can :manage, EmailSettings


      # Comments
      can :manage, Comment
    end


    ################
    # Other users

    # Users
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
    can :social, User do |u|
      u == user
    end
    can :facebook_friends, User do |u|
      u == user
    end
    can :locale, User
    can :find_friends, User
    can :sign_in_popup, User


    # EmailSettings
    can :update, EmailSettings do |settings|
      settings.try(:user) == user
    end


    # Options
    can :read, Option
    can :votes, Option do |option|
      (not option.battle.current?) || (option.battle.try(:user) == user) || (user.vote_for(option.battle))
    end


    # Battles
    can :create, Battle
    can :update, Battle do |battle|
      (not battle.finished?) && (battle.try(:user) == user)
    end
    can :destroy, Battle do |battle|
      battle.try(:user) == user
    end
    can :show, Battle do |battle|
      ((not battle.in_future?) || (battle.try(:user) == user)) && (not battle.hidden)
    end
    can :show_results, Battle do |battle|
      (not battle.current?) || (battle.try(:user) == user) || (user.vote_for(battle))
    end
    can :hashtag, Battle


    # Votes
    can :create, Vote


    # Friendships
    can :create, Friendship
    can :destroy, Friendship do |friendship|
      friendship.try(:user) == user
    end


    # Notifications
    can :create, Notification
    can :read, Notification do |notification|
      notification.try(:user) == user
    end
    can :dropdown, Notification


    # Comments
    can :create, Comment do |comment|
      comment.try(:user) == user
    end
    can :read, Comment
    can :destroy, Comment do |comment|
      (comment.try(:user) == user) || (comment.try(:battle).try(:user) == user)
    end
  end
end
