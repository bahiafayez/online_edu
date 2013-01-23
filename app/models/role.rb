class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true
  
  def to_s
    if name == "admin"
      "Teacher"
    elsif name =="user"
      "Student"
    end
  end
    
  def display_name
    if name == "admin"
      "Teacher"
    elsif name =="user"
      "Student"
    end
  end
  
  scopify
end
