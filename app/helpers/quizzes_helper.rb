module QuizzesHelper
  
  def alert_messages
    message=""
    @alert_messages.each do |m|
      message+=m + "<br\>"
    end
    return message
  end
end
