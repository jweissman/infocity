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
        # "pawn[space_id]" => 1,
        # "pawn[name]" => "Guest1234",
        # "pawn[status]" => "Just hanging",
        "pawn[pawn_key]" => pawn_key
      }
      post_create_pawn.set_form_data( pawn_params ) #.to_json
      response = @http.request(post_create_pawn)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
