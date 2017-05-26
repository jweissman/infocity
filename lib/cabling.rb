require 'space_elevator'
require 'eventmachine'
require 'em-websocket-client'

EventMachine.run do

  url = 'ws://0.0.0.0:9292/cable'
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
                    client.publish({channel: 'ChatChannel'}, {subject: 'Hi', text: "What's up, y'all!?!?"})
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
