class PawnsController < ApplicationController
  def awaken
    logger.info "AWAKEN"
    logger.info "Was given pawn key?"
    if pawn_params[:pawn_key]
      logger.info "---> GOT PAWN KEY: #{pawn_params[:pawn_key]}"
      pawn_key_value = pawn_params[:pawn_key]
      @key = PawnKey.find_by(value: pawn_key_value)
      if @key
        @pawn = @key.pawn
        # @space = @key.space
        logger.info "---> FOUND PAWN KEY UNLOCKS: #{@pawn.inspect}"
        # @pawn.update(status: 'awake!')

        # @pawn = @space.pawns.first_or_create!
        # @pawn.update space: space

        render json: @pawn, include: {
          :space => {:include => [ :cartogram ]}
        }
      else
        render json: { error: 'you need to provide a valid/active management key to awaken a pawn' }
      end
    else
      render json: { error: 'you need to provide a valid/active management key to awaken a pawn' }
    end
  end

  # def move; end

  protected
  def pawn_params
    params.require(:pawn).permit(:name, :status, :space_id, :pawn_key)
  end
end
