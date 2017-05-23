class SpacesController < ApplicationController
  def show
    @space = Space.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render json: @space, include: [ :cartogram ]
      end
    end
  end
end
