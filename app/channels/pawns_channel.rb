class PawnsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "pawns"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # go to sleep??
  end

  def awaken
    Rails.logger.info "#{current_pawn.name} AWAKEN"
    # current_pawn.update(status: 'awake')
    # pawns = current_pawn.space.pawns

    ActionCable.server.broadcast 'pawns',
      space: current_pawn.space.as_json(include: [ :cartogram, :pawns ])
  end

  def move(data)
    Rails.logger.info "#{current_pawn.name} MOVE #{data['direction']}"
    current_pawn.go(data['direction'])
    ActionCable.server.broadcast 'pawns',
      space: current_pawn.space.reload.as_json(include: [ :cartogram, :pawns ])
  end

  def speak
    Rails.logger.info "#{current_pawn.name} SPEAK"
  end

  # def message(data)
  #   Rails.logger.info "MESSAGE: #{data}"
  # end
end
