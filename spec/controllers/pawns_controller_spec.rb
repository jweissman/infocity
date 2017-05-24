require 'rails_helper'

RSpec.describe PawnsController, type: :controller do
  describe "GET #create" do
    it "returns http success" do
      space = Space.create!(cartogram: Cartogram.new)
      get :create, params: { pawn: { space_id: space.id, name: 'tim thomson', status: 'timming it' } }
      expect(response).to have_http_status(:success)
    end
  end
end
