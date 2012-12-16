class Confused < ActiveRecord::Base
  attr_accessible :course_id, :lecture_id, :time, :user_id
  
  
  def self.get_rounded_time(array)
    return_hash={}
    Time.zone="UTC"
    array.each do |c|
        parsed_time=Time.zone.parse(Time.seconds_to_time(c.time+1)).ceil(1.minute).to_i #currently rounding to nearest minute. could change that. #to_i to use it in javascript
        puts "parsed time issssss #{parsed_time}"
        puts "time zone isssss #{Time.zone}"
        return_hash[parsed_time] = (return_hash[parsed_time]||0) + 1
    end
    return return_hash.to_a    
  end
  
end
