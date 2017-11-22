class StoriesChannel < ApplicationCable::Channel

  def subscribed
    @streamer = TwitterWorker.new(params[:latitude], params[:longitude])
    @streamer.run

    stream_from "stories_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    @streamer.terminate
  end
end
