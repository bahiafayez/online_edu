require 'mechanize'
require 'logger'

agent = Mechanize.new
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

page = agent.get "https://piazza.com/"
page.link_with(:dom_class => "login button").click()

search_form = page.form_with :id => "login-form"
search_form.field_with(:name => "email").value = "bahia.sharkawy@gmail.com"
search_form.field_with(:name => "password").value = "trial.123"

search_results = agent.submit search_form
puts search_results.body

search_results.link_with(:id => "NewPostButton").click()
search_results.field_with(:id => "newQuestionSubject").value = "oppa"
search_results.field_with(:id => "tinymce").value = "oppa text"
posted=search_results.link_with(:id => "newPostButton").click()
puts posted.body
#class: UITab postQuestionTab <div>
#id: newQuestionSubject <textarea>
#id: tinymce  <body>
#id: newQuestionTags <textarea> should start with #
#id: newPostButton <a> 

###################### Logged in ############################
#### wont work since mechanize does not work with javascript, will use capybara instead. ######

#require 'capybara/rails'
#Capybara.app = MyRackApp
# require 'watir'
# require 'watir-webdriver'
# browser = Watir::Browser.new
# browser.goto 'https://piazza.com/'
# browser.link(:class => 'login button').click


#visit("https://piazza.com/")
#click_link('id-of-link')
#find(".login button").click()
#fill_in('email', :with => 'bahia.sharkawy@gmail.com')
#fill_in('password', :with => 'trial123')
#click_link("primary button")
#find(".primary button").click
#save_and_open_page
#page.link_with(:id => "NewPostButton").click()
#page.click()

