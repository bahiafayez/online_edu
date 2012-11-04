class Question < ActiveRecord::Base
  
  belongs_to :quiz
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :allow_destroy => true
  
  attr_accessible :content, :quiz_id, :answers_attributes
  validates :content, :presence => true
  
end
