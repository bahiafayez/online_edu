# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OnlineEdu::Application.initialize!

Time::DATE_FORMATS.merge!({:default => '%d %b (%a)'})
#Date::DATE_FORMATS.merge!({:default => '%d %b (%a)'})