# tiny, self-contained client

require 'net/http'
require 'json'
require 'curses'

module Infocity
  class Client
    def initialize(host: 'localhost', port: 3000)
      @host = host
      @port = port
    end

    def connect!
      @http = Net::HTTP.new(@host, @port)
    end

    def awaken_pawn(pawn_key:)
      post_create_pawn = Net::HTTP::Post.new("/pawns/awaken")
      pawn_params = {
        "pawn[pawn_key]" => pawn_key
      }
      post_create_pawn.set_form_data( pawn_params ) #.to_json
      submit post_create_pawn
    end

    def move_pawn(pawn_key:, direction:)
      post_move_pawn = Net::HTTP::Post.new("/pawns/move")
      pawn_params = {
        "pawn[direction]" => direction,
        "pawn[pawn_key]"  => pawn_key
      }

      post_move_pawn.set_form_data(pawn_params)
      submit post_move_pawn
    end

    protected
    def submit(request)
      response = @http.request(request)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
