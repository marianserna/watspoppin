class StoriesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  # data == messages sent to server (in this case it contains content & user_name)
  # def update(data)
  #   chat = Chat.find_by(uuid: params[:chat_uuid])
  #
  #   message = chat.messages.create!(
  #     content: data['content'],
  #     user_name: data['user_name']
  #   )
  #   # broadcast checkin to subscribers
  #   # message.attributes: object to hash
  #   ActionCable.server.broadcast("chat_#{params[:chat_uuid]}", message.attributes)
  # end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
