module CoursesHelper
  
def link_to_user(count)
#options[:class] = options.has_key?(:class) ? "#{options[:class]} user-link" : ""
content_tag :div, :class => "accordian-body collapse", :id => "collapse#{count}" do
  "d"
end

  #link_to(text, user, options) +
  #content_tag(:span, :style => "display: none;", :class => "userbox") do
  #  content_tag(:span, :class => "fn") do
  #    content_tag(:span, :class => "given-name") do user.firstname
  #     end +
 #     content_tag(:span, :class => "family-name") do #user.lastname 
 #      end
    #end 
end 

end
