
  desc "Erase and fill database"
  task :role_adjust => :environment do  #must add => environment to be able to access the models..
     User.all.each do |a|
       a.roles=[Role.find(2)]
     end
     User.first.roles=[Role.find(1)]
  end