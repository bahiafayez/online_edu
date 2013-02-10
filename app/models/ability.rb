class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, [Announcement, Course, Evaluation,Event, Group, Lecture, OnlineQuiz, Quiz]
      cannot :courseware, Course
      cannot :student_show, Course
      cannot :progress, Course
      cannot :index, Event
      #cannot :index, User
    elsif user.has_role? :user
      can :read, Course
      can :student_show, Course
      can :progress, Course
      can :courseware, Course
      can :student_quiz, Course
      cannot :show, Course
      cannot :manage, Lecture
      cannot :manage, Quiz
      can :student_notifications, Course
      can [:index,:show], Event
      can :enroll, User
      can :enroll_to_course, User
    else
      can :index, Course  #so that people without role can live until they get a role.
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
