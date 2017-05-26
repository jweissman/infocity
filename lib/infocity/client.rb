# tiny, self-contained client

require 'pry'
require 'net/http'
require 'json'
require 'curses'

require 'em-websocket-client'
require 'space_elevator'

module Infocity
  class Client
    attr_reader :pawn_id

    def initialize(host: '0.0.0.0', port: 3000, pawn_key:, handler_callback:)
      @host = host
      @port = port
      @http = Net::HTTP.new(host, port) #"http://#{host}:#{port}")
      @pawn_key = pawn_key
      @handler_callback = handler_callback
      @log = Logger.new('log/client.log')

      pawn_details = dereference_pawn_key #[:pawn][:id]
      # binding.pry
      @pawn_id = pawn_details[:id]
      @pawn_name = pawn_details[:name]
      @log.info "WE ARE PAWN ID #@pawn_id (#@pawn_name)"
    end

    def send_ws(action:, data: {})
      # @ws_client.pu
      @ws_client.publish({channel: 'PawnsChannel'}, { action: action }.merge(data)) #, subject: 'Hi', text: "What's up, y'all!?!?"})
    end

    def connect!
      @log.info "=== WS CLIENT CONNECT ==="
      # uri = "ws://#@host:#@port/cable?pawn_key=#@pawn_key"
      uri = "ws://#@host:#@port/cable?pawn_key=#@pawn_key" #d5b4d11c-798f-47dd-acee-e0ebde9f5ff6"
      @log.info "--- connect to #{uri} ---"

      EventMachine.run do
        # Create a SpaceElevator::Client with a disconnect handler.
        @ws_client = SpaceElevator::Client.new(uri) do
          @log.info 'Disconnected. Exiting...'
          EventMachine.stop_event_loop
        end

        @log.info "...connecting..."

        # Connect the client using the provided callback block.
        @ws_client.connect do |msg|
          @log.info "GOT MSG"
          case msg['type'] # The server will always set a 'type'.
          when 'welcome' # Sent after a successful connection.
            @log.info 'The server says "welcome".'

            # Subscribe to something..
            @ws_client.subscribe(channel: 'PawnsChannel') do |chat|
              @log.info "Received pawn Event: #{chat}"
              if chat['type'] == 'confirm_subscription'
                @log.info "Subscription to #{chat['identifier']['channel']} confirmed!"

                @ws_client.publish({channel: 'PawnsChannel'}, { action: 'awaken' }) #, subject: 'Hi', text: "What's up, y'all!?!?"})
              else
                @log.info chat
                @handler_callback.call(chat)
              end
            end

            # Subscribe to something else simultaneously. Note the additional parameters!
            # client.subscribe(channel: 'PlatformChannel', platform_id: platform_id) do |m|
            #     @log.info "Received Platform #{platform_id} Event: #{m}"
            #     # Do whatever, here.
            # end
          when 'ping'
            @log.info 'The server just pinged us.'
          else
            @log.info msg
            # @handler_callback.call(msg)
          end
        end

        # adds to a queue that is purged upon receiving of
        # a ping from the server
        #   cable.perform('speak', { message: 'hello from amc' })
        # end
      end
      # quit!
      # raise 'disconnect'
      @log.info "=== WS CLIENT CONNECT COMPLETE ==="
    rescue
      @log.error $!
    end

    def dereference_pawn_key
      deref_pawn_key = Net::HTTP::Get.new("/pawns/deref") #?pawn_key=#@pawn_key")
      pawn_params = { "pawn[pawn_key]" => @pawn_key }
      deref_pawn_key.set_form_data(pawn_params)
      submit deref_pawn_key
    end

    def awaken_pawn #(pawn_key:)
      @log.info 'Client#awaken_pawn not impl'
      # post_create_pawn = Net::HTTP::Post.new("/pawns/awaken")
      # pawn_params = {
      #   "pawn[pawn_key]" => pawn_key
      # }
      # post_create_pawn.set_form_data( pawn_params ) #.to_json
      # submit post_create_pawn
    end

    def move_pawn(direction:)
      raise 'not impl'
      # post_move_pawn = Net::HTTP::Post.new("/pawns/move")
      # pawn_params = {
      #   "pawn[direction]" => direction,
      #   "pawn[pawn_key]"  => pawn_key
      # }

      # post_move_pawn.set_form_data(pawn_params)
      # submit post_move_pawn
    end

    protected
    def submit(request)
      response = @http.request(request)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
