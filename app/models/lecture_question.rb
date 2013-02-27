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
  
  def self.get_rounded_time_30(array)
    return_hash={}
    questions={}
    Time.zone="UTC"
    array.each do |c|
        parsed_time=Time.zone.parse(Time.seconds_to_time(c.time)).round(30.seconds).to_i #currently rounding to nearest minute. could change that. #to_i to use it in javascript
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
  
  def self.get_rounded_display(array)
    return_hash={}
    questions={}
    Time.zone="UTC"
    array.each do |c|
        parsed_time_m=Time.zone.parse(Time.seconds_to_time(c.time)).round(30.seconds).min
        parsed_time_s=Time.zone.parse(Time.seconds_to_time(c.time)).round(30.seconds).sec
        parsed_time_h=Time.zone.parse(Time.seconds_to_time(c.time)).round(30.seconds).hour
        parsed_time= parsed_time_s + parsed_time_m.minutes.to_i + parsed_time_h.hours.to_i
        return_hash[parsed_time] = (return_hash[parsed_time]||0) + 1
        if questions[parsed_time]
          questions[parsed_time] << [c.question,c.time]
         else
           questions[parsed_time] = [[c.question,c.time]]
         end
    end
    return_hash.merge!(questions){|k,v1,v2| [v1,v2]}
    return return_hash   
  end
  
end
