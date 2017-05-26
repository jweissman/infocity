# tiny, self-contained client

require 'pry'
require 'net/http'
require 'json'
require 'curses'
require 'action_cable_client'

module Infocity
  class Client
    def initialize(host: 'localhost', port: 3000)
      @host = host
      @port = port
      @log = Logger.new('log/client.log')
    end

    def connect!
      @log.info "=== HTTP CLIENT CONNECT ==="
      @http = Net::HTTP.new(@host, @port)
      @log.info "=== HTTP CLIENT CONNECT COMPLETE ===" # ?
    end

    def connect_ws!
      @log.info "=== WS CLIENT CONNECT ==="
      uri = "ws://localhost:3000/cable/"
      @cable = ActionCableClient.new(uri, 'MessagesChannel')
      binding.pry
      # the connected callback is required, as it triggers
      # the actual subscribing to the channel but it can just be
      # client.connected {}
      @cable.connected do
        @log.info 'successfully connected!'
      end

      # called whenever a message is received from the server
      @cable.received do | message |
        @log.info message
      end

      # adds to a queue that is purged upon receiving of
      # a ping from the server
      # cable.perform('speak', { message: 'hello from amc' })
      # end
      @log.info "=== WS CLIENT CONNECT COMPLETE ==="
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
