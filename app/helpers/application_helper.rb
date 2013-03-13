module ApplicationHelper
  
  def parent_layout(layout)
    #@_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end  
  
  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
  
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
  
end


# adding functionality to the Time class.
class Time
  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds).utc
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds).utc
  end
  
  def ceil(seconds = 60)
    Time.at((self.to_f / seconds).ceil * seconds).utc
  end
  
  def self.seconds_to_time(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
