module MessagesHelper
  def message_time(message)
    message.created_at.strftime('%H:%M:%S %d %B %Y')
  end
end
