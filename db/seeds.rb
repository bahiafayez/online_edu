# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'CREATING ROLES'
Role.create([
  { :name => 'admin' }, 
  { :name => 'user' }, 
  { :name => 'VIP' }
], :without_protection => true)
#puts 'SETTING UP DEFAULT USER LOGIN'
#user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
#puts 'New user created: ' << user.name
#user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
#puts 'New user created: ' << user2.name
#user.add_role :admin
#user2.add_role :VIP


#populate here.. say 1 teacher, 1 course, 2 modules, each with 5 lectures, 20 students taking the course, 
#solve some lecture quizzes, enough data for charts..

Time.zone="Cairo"

user = User.create! :name => 'Teacher', :email => 'teacher@email.com', :password => 'password', :password_confirmation => 'password'
user.add_role :admin

course= Course.new :short_name => 'CS-201', :name => "Computer Architecture", :start_date => Time.zone.now, :duration => 12, :description => "This course forms a strong foundation in the understanding and design of modern computing systems. Building on a computer organization base, this course explores techniques that go into designing a modern microprocessor. Fundamental understanding of computer architecture is key not only for students interested in hardware and processor design, but is a foundation for students interested in compilers, operating systems, and high performance programming. This course will explore how the computer architect can utilize the increasing number of transistors available to improve the performance of a processor. Focus will be given to architectures that can exploit different forms of parallelism, whether they be implicit or explicit. This course covers architectural techniques such as multi-issue superscalar processors, out-of-order processors, Very Long Instruction Word (VLIW) processors, advanced caching, and multiprocessor systems.", :prerequisites => "This course is targeted at senior-level undergraduates and first-year graduate students. Students should have a good working understanding of digital logic, basic processor design and organization, pipelining, and simple cache design.", :time_zone => "Cairo"
user.subjects << course

9.upto(10).each do |index|
  group= Group.new :name => "Lecture#{index}", :appearance_time => Time.zone.now, :due_date => 2.weeks.from_now, :position => index
  course.groups << group
  if index==9
    ["http://www.youtube.com/watch?v=OrDaQ1WY_DM", "http://www.youtube.com/watch?v=GoFRETVkKz8", "http://www.youtube.com/watch?v=olFaINw9UUg", "http://www.youtube.com/watch?v=kq-Ggo-RDzA", "http://www.youtube.com/watch?v=cNAJ2Xu7XlI", "http://www.youtube.com/watch?v=1wRP8eDcZdc"].each_with_index do |url,i|
      lecture= Lecture.new :name => "Part#{i}", :course_id => course.id, :url => url, :appearance_time => group.appearance_time, :due_date => group.due_date, :duration => 600, :slides => "http://www.ci.uchicago.edu/about/pdf/UChicago-Postdoc-Advert8-2012v1.pdf"
      group.lectures<< lecture
    end
  else
    ["http://www.youtube.com/watch?v=3FBAYk34jhE", "http://www.youtube.com/watch?v=l9tTtUbfxFM", "http://www.youtube.com/watch?v=65dc6K6nJE8", "http://www.youtube.com/watch?v=qCozcVfYWEM", "http://www.youtube.com/watch?v=xlfyfndqP4s", "http://www.youtube.com/watch?v=4FfJTgERjYA"].each_with_index do |url,i|
      lecture= Lecture.new :name => "Part#{i}", :course_id => course.id, :url => url, :appearance_time => group.appearance_time, :due_date => group.due_date, :duration => 600, :slides => "http://www.ci.uchicago.edu/about/pdf/UChicago-Postdoc-Advert8-2012v1.pdf"
      group.lectures<< lecture
    end
  end
end

1.upto(20).each do |index|
  user = User.create! :name => "Student #{index}", :email => "student#{index}@email.com", :password => 'password', :password_confirmation => 'password'
  user.add_role :user
  user.courses << course
end

