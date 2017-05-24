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

    def retrieve_space_details
      get_space_details = Net::HTTP::Get.new("/spaces/1.json")
      response = @http.request(get_space_details)
      JSON.parse(response.body)
    end

    def awaken_pawn(pawn_key:)
      post_create_pawn = Net::HTTP::Post.new("/pawns/create")
      post_create_pawn.set_form_data({
        "space_id" => 1,
        "name" => "Guest1234",
        "status" => "Just hanging",
        "pawn_key" => pawn_key
      })
      response = @http.request(post_create_pawn)
      JSON.parse(response.body)
    end
  end
end
