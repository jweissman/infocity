require 'rails_helper'

RSpec.describe PawnsController, type: :controller do
  describe "POST #awaken" do
    it "returns http success" do
      space = Space.create!(cartogram: Cartogram.new)
      pawn = Pawn.create!(space: space)
      pawn_key = PawnKey.create!(pawn: pawn)
      post :awaken, params: { pawn: { pawn_key: pawn_key.value }}
      expect(response).to have_http_status(:success)

      pawn_data = JSON.parse(response.body, symbolize_names: true)

      expect(pawn_data[:id]).to eq(pawn.id)
      expect(pawn_data[:space][:id]).to eq(space.id)
    end
  end
end
