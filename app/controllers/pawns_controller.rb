class PawnsController < ApplicationController
  before_action :extract_pawn_key

  def awaken
    logger.info "AWAKEN PAWN"
    @pawn = @pawn_key.pawn
    @pawn.update(status: 'awake')
    render json: @pawn, include: {
      :space => {:include => [ :cartogram, :pawns ]}
    }
  end

  def move
    logger.info "MOVE PAWN #{pawn_params[:direction]}"
    @pawn.go(pawn_params[:direction])
    render json: @pawn, include: {
      :space => {:include => [ :cartogram, :pawns ]}
    }
  end

  protected
  def extract_pawn_key
    if pawn_params[:pawn_key]
      pawn_key_value = pawn_params[:pawn_key]
      @pawn_key = PawnKey.find_by(value: pawn_key_value)
      logger.info "---> FOUND PAWN KEY!"
      if @pawn_key.pawn
        @pawn = @pawn_key.pawn
        logger.info "---> FOUND PAWN KEY UNLOCKS: #{@pawn.inspect}"
        return true
      end
    end

    render json: { error: 'you need to provide a valid/active management key' }
  end

  def pawn_params
    params.require(:pawn).permit(:name, :status, :space_id, :pawn_key, :direction)
  end
end
