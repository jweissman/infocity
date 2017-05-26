# require 'action_cable_client'

# EventMachine.run do
# 
#   uri = "ws://0.0.0.0:3000/cable/"
#   client = ActionCableClient.new(uri, 'PawnsChannel')
#   # the connected callback is required, as it triggers
#   # the actual subscribing to the channel but it can just be
#   # client.connected {}
#   client.connected { puts 'successfully connected.' }
# 
#   # called whenever a message is received from the server
#   client.received(false) do |message|
#     puts message
#   end
# 
#   # adds to a queue that is purged upon receiving of
#   # a ping from the server
#   puts "---> perform..."
#   client.perform('speak', { message: 'hello from joe' })
# end

require 'space_elevator'
require 'eventmachine'
require 'em-websocket-client'

EventMachine.run do

  url = 'ws://0.0.0.0:3000/cable?pawn_key=d5b4d11c-798f-47dd-acee-e0ebde9f5ff6' #0.0.0.0:9292/cable'
  puts "--- connect to #{url} ---"

    # Create a SpaceElevator::Client with a disconnect handler.
    client = SpaceElevator::Client.new(url) do
        puts 'Disconnected. Exiting...'
        EventMachine.stop_event_loop
    end

    # Connect the client using the provided callback block.
    client.connect do |msg|
        case msg['type'] # The server will always set a 'type'.
        when 'welcome' # Sent after a successful connection.
            puts 'The server says "welcome".'

            # Subscribe to something..
            client.subscribe(channel: 'PawnsChannel') do |chat|
                puts "Received pawn Event: #{chat}"
                if chat['type'] == 'confirm_subscription'
                    puts "Subscription to #{chat['identifier']['channel']} confirmed!"

                    # Broadcast to the channel! The actual channel identifier and message payload is specific to your backend's WebSocket API.
                    puts "---> publish..."
                    client.publish({channel: 'PawnsChannel'}, { action: 'speak', subject: 'Hi', text: "What's up, y'all!?!?"})
                end
            end

            # Subscribe to something else simultaneously. Note the additional parameters!
            # client.subscribe(channel: 'PlatformChannel', platform_id: platform_id) do |m|
            #     puts "Received Platform #{platform_id} Event: #{m}"
            #     # Do whatever, here.
            # end
        when 'ping'
            puts 'The server just pinged us.'
        else
            puts msg
        end
    end
end
