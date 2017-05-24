class PawnsController < ApplicationController
  def create
    # verify space id???
    # verify mgmt key?
    @pawn = Pawn.new(pawn_params)
    if @pawn.save
      render json: @pawn
    end
  end

  # def move; end

  protected
  def pawn_params
    params.require(:pawn).permit(:name, :status, :space_id)
  end
end
