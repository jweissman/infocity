class PawnsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "pawns"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def awaken
  end

  def move
  end

  def speak
  end
end
