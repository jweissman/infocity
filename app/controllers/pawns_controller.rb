class PawnsController < ApplicationController
  before_action :extract_pawn_key

  def awaken
    logger.info "AWAKEN"
    @pawn = @pawn_key.pawn
    @pawn.update(status: 'awake')
    render json: @pawn, include: {
      :space => {:include => [ :cartogram ]}
    }
  end

  def move
    logger.info "MOVE PAWN #{pawn_params[:direction]}"
    # logger.info "was given pawn key?"
    @pawn.go(pawn_params[:direction])
    render json: @pawn, include: {
      :space => {:include => [ :cartogram ]}
    }
  end

  protected
  def extract_pawn_key
    if pawn_params[:pawn_key]
      pawn_key_value = pawn_params[:pawn_key]
      @pawn_key = PawnKey.find_by(value: pawn_key_value)
      @pawn = @pawn_key.pawn
      logger.info "---> FOUND PAWN KEY UNLOCKS: #{@pawn.inspect}"
    else
      render json: { error: 'you need to provide a valid/active management key' }
    end
  end

  def pawn_params
    params.require(:pawn).permit(:name, :status, :space_id, :pawn_key, :direction)
  end
end
