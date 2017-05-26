class PawnsController < ApplicationController
  before_action :extract_pawn_key

  def deref
    @pawn = @pawn_key.pawn
    render json: @pawn
  end

  protected
  def extract_pawn_key
    if pawn_params[:pawn_key]
      pawn_key_value = pawn_params[:pawn_key]
      @pawn_key = PawnKey.find_by(value: pawn_key_value)
      logger.info "---> FOUND PAWN KEY!"
      if @pawn_key.pawn
        @pawn = @pawn_key.pawn
        logger.info "---> FOUND PAWN THAT KEY UNLOCKS: #{@pawn.inspect}"
        return true
      end
    end

    render json: { error: 'you need to provide a valid/active management key' }
  end

  def pawn_params
    params.require(:pawn).permit(:pawn_key)
  end
end
