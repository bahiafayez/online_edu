class LectureQuestion < ActiveRecord::Base
  attr_accessible :course_id, :lecture_id, :question, :time, :user_id
  
  
  validates :course_id, :lecture_id, :question, :time, :user_id, :presence => true
  
  def self.get_rounded_time(array)
    return_hash={}
    questions={}
    Time.zone="UTC"
    array.each do |c|
        parsed_time=Time.zone.parse(Time.seconds_to_time(c.time)).floor(15.seconds).to_i #currently rounding to nearest minute. could change that. #to_i to use it in javascript
        puts "parsed time issssss #{parsed_time}"
        puts "time zone isssss #{Time.zone}"
        puts "ceil #{Time.seconds_to_time(c.time+1)}"
        print "parsed #{Time.zone.parse(Time.seconds_to_time(c.time+1))}"
        return_hash[parsed_time] = (return_hash[parsed_time]||0) + 1
        if questions[parsed_time]
          questions[parsed_time] << c.question
         else
           questions[parsed_time] = [c.question]
         end
    end
    return_hash.merge!(questions){|k,v1,v2| [v1,v2]}
    return return_hash   
  end
  
end
