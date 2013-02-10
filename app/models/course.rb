class Course < ActiveRecord::Base
  belongs_to :user
  has_many :quizzes, :dependent => :destroy
  has_many :enrollments, :dependent => :delete_all
  has_many :users, :through => :enrollments, :uniq => true
  has_many :lectures, :dependent => :destroy
  has_many :groups, :order => "position", :dependent => :destroy
  has_many :events
  has_many :announcements, :dependent => :destroy
  
  attr_accessible :description, :duration, :name, :prerequisites, :short_name, :start_date, :user_ids, :user_id, :time_zone
  
  validates :name, :duration, :short_name,:start_date, :user_id, :time_zone, :presence => true
  validates :duration, :numericality => { :only_integer => true }
  validates_date :start_date
  
  accepts_nested_attributes_for :users, :allow_destroy => true
  accepts_nested_attributes_for :groups, :allow_destroy => true
  attr_accessible :users_attributes, :groups_attributes, :lectures_attributes
  #attr_accessible :enrollment_attributes
  
  before_create :create_unique_identifier

  def create_unique_identifier
    begin
      self. unique_identifier = SecureRandom.hex(5) # or whatever you chose like UUID tools
    end while self.class.exists?(:unique_identifier => unique_identifier)
  end


  
  def self.our(user)
    if User.find(user).has_role? :admin
      return User.find(user).subjects
    else
      return User.find(user).courses
    end
  end
  
  def enrolled_students #returns scope (relation)
    return User.joins(:courses).where("course_id = ?", id)
  end
  
  def not_enrolled_students #returns scope (relation)
    #u=User.all
    a=enrolled_students.pluck("users.id")
    u=User.joins(:roles).where(:roles =>{:name => "user"}).where("users.id NOT IN (?)",a)
  end
end
