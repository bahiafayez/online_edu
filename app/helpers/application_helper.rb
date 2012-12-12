module ApplicationHelper
  
  def parent_layout(layout)
    #@_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end
  
end


# adding functionality to the Time class.
class Time
  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
  
  def ceil(seconds = 60)
    Time.at((self.to_f / seconds).ceil * seconds)
  end
  
  def self.seconds_to_time(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
