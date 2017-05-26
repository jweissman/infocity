module Infocity
  module Screen
    class Model
      attr_reader :name, :description, :cartogram, :pawn, :others
      def initialize(name:, description:, cartogram:, pawn:, others:)
        @name = name
        @description = description
        @cartogram = cartogram
        @pawn = pawn
        @others = others
      end
    end


    # main app view
    class View < Swearing::Component
      def draw(model)
        name = Swearing::Label.new(x: 2, y: 1, text: "NAME: #{model.name}") # | DESCRIPTION: #{model.description}")
        name.draw

        description = Swearing::Label.new(x: 2, y: 2, text: "DESCRIPTION: #{model.description}")
        description.draw

        grid = Swearing::Grid.new(
          x: 0, y: 0,
          legend: { 0 => ' ', 1 => '.', 2 => '_', 3 => '|' },
          field: model.cartogram
        )

        if model.pawn
          pawn_sigil = Swearing::Sigil.new(x: model.pawn[:x], y: model.pawn[:y], figure: '@', text: model.pawn[:name] + " (you)")
          grid.show(pawn_sigil)
        end

        if model.others.any?
          log.info "---> would draw others"
          model.others.each do |other|
            other_sigil = Swearing::Sigil.new(x: other[:x], y: other[:y], figure: '^', text: other[:name])
            grid.show(other_sigil)
          end
        end

        container = Swearing::Container.new(width: cols, height: lines, elements: [ grid ] )
        container.draw
      end
    end

    class App
      def initialize(pawn_key:)
        @view   = View.new
        @client = Client.new

        @pawn_key = pawn_key

        @ui = Swearing::UI.new(
          keypress: method(:press),
          view: method(:render)
        )
      end

      def boot!
        @client.connect!

        awaken_data  = @client.awaken_pawn(pawn_key: @pawn_key)
        if awaken_data[:error]
          puts "---> ERROR: #{awaken_data[:error]}"
          exit(-1)
          # raise 'unable to awaken pawn'
        else
          @ui.log.info "awaken data: #{awaken_data}"
          update_model(awaken_data)
        end
      end

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
        pawn_data = @client.move_pawn(pawn_key: @pawn_key, direction: direction)
        update_model(pawn_data)
      end

      def update_model(data)
        pawn_details = data
        space_details = pawn_details[:space]
        @ui.log.info "pawn: #{pawn_details}"

        @model  = Model.new(
          name: space_details[:name],
          description: space_details[:description],
          cartogram: space_details[:cartogram][:structure],
          pawn: {
            x: pawn_details[:x],
            y: pawn_details[:y],
            name: pawn_details[:name],
            status: pawn_details[:status]
          },
          others: space_details[:pawns].reject { |the_pawn| the_pawn[:id] == pawn_details[:id] }
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
        EventMachine.run do
          @ui.log.info "em run"
          # puts "=== SCREEN"
          boot!
          @client.connect_ws!
          @ui.launch!
        end
      end
    end
  end
end
