
require 'eventmachine'
module Infocity
  module Screen
    class Model
      attr_reader :name, :description, :cartogram, :pawns #, :pawn, :others
      def initialize(name:, description:, cartogram:, pawns:) # , pawn:, others:)
        @name = name
        @description = description
        @cartogram = cartogram
        @pawns = pawns
        # @pawn = pawn
        # @others = others
      end
    end


    # main app view
    class View < Swearing::Component
      def draw(model)
        unless model
          log.info "(NO MODEL DATA)"
          return
        end
        name = Swearing::Label.new(x: 2, y: 1, text: "NAME: #{model.name}") # | DESCRIPTION: #{model.description}")
        name.draw

        description = Swearing::Label.new(x: 2, y: 2, text: "DESCRIPTION: #{model.description}")
        description.draw

        grid = Swearing::Grid.new(
          x: 0, y: 0,
          legend: { 0 => ' ', 1 => '.', 2 => '_', 3 => '|' },
          field: model.cartogram
        )

        # if model.pawn
        #   pawn_sigil = Swearing::Sigil.new(x: model.pawn[:x], y: model.pawn[:y], figure: '@', text: model.pawn[:name] + " (you)")
        #   grid.show(pawn_sigil)
        # end

        if model.pawns.any?
          log.info "---> would draw pawns"
          model.pawns.each do |pawn|
            sigil = Swearing::Sigil.new(x: pawn[:x], y: pawn[:y], figure: pawn[:you] ? '@' : '^', text: pawn[:name])
            grid.show(sigil)
          end
        end

        container = Swearing::Container.new(width: cols, height: lines, elements: [ grid ] )
        container.draw
      end
    end

    class App
      def initialize(pawn_key:)
        @view   = View.new
        @client = Client.new(pawn_key: pawn_key, handler_callback: method(:receive))

        # @pawn_key = pawn_key

        @ui = Swearing::UI.new(
          keypress: method(:press),
          view: method(:render)
        )
      end

      def receive(event)
        @ui.log.info "GOT MESSAGE FROM SERVER: #{event.inspect}"
        update_model(event['message'])
      end

      # def boot!
      #   @client.connect!

      #   # awaken_data  = @client.awaken_pawn #(pawn_key: @pawn_key)

      #   @ui.log.info "attempted to connect..."

      #   # if awaken_data[:error]
      #   #   puts "---> ERROR: #{awaken_data[:error]}"
      #   #   exit(-1)
      #   #   # raise 'unable to awaken pawn'
      #   # else
      #   #   @ui.log.info "awaken data: #{awaken_data}"
      #   #   # update_model(awaken_data)
      #   # end
      # end

      def render
        @view.draw(@model)
      end

      def press(key)
        @ui.log.info "pressed #{key}"
        if key == 'x' || key == 'q'
          @ui.quit!
        else
          case key
          when 'h', 'j', 'k', 'l' then move(direction_for(key))
          else @ui.log.info "no mapping for key '#{key}'"
          end
        end
      end

      def move(direction)
        @ui.log.info "WOULD MOVE #{direction}"
        @client.send_ws(action: 'move', data: { direction: direction })
        # pawn_data = @client.move_pawn(pawn_key: @pawn_key, direction: direction)
        # update_model(pawn_data)
      end

      def update_model(data)
        space_details = data['space']
        pawns_details = space_details['pawns']
        @ui.log.info "pawns: #{pawns_details}"
        @ui.log.info "space: #{space_details}"

        @model  = Model.new(
          name: space_details['name'],
          description: space_details['description'],
          cartogram: space_details['cartogram']['structure'],
          pawns: pawns_details.map do |pawn_detail|
            {
              x: pawn_detail['x'],
              y: pawn_detail['y'],
              name: pawn_detail['name'],
              id: pawn_detail['id'],
              you: pawn_detail['id'].to_i == @client.pawn_id
            }
          end
          # pawn: {
          #   x: pawn_details['x'],
          #   y: pawn_details['y'],
          #   name: pawn_details['name'],
          #   status: pawn_details['status']
          # },
          # others: space_details[:pawns].reject { |the_pawn| the_pawn[:id] == pawn_details[:id] }
        )
      end

      def direction_for(key)
        {
          'k' => 'north',
          'j' => 'south',
          'h' => 'east',
          'l' => 'west'
        }[key]
      end

      def launch!
        # EventMachine.run do
          @ui.log.info "======== screen launch!!! ======="
          # puts "=== SCREEN"
          @comms_thread = Thread.new { @client.connect! } #; @ui.log.info "connected!" } #; @ui.quit! }
          @ui.log.info "UI LAUNCH"
          # @client.connect!
          @ui.launch!
        # end
      end
    end
  end
end
