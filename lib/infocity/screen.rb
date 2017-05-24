module Infocity
  module Screen
    class Model
      attr_reader :name, :description, :cartogram
      def initialize(name:, description:, cartogram:)
        @name = name
        @description = description
        @cartogram = cartogram
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
        space_details = @client.retrieve_space_details
        # pawn_details  = @client.awaken_pawn(pawn_key: pawn_key)

        @ui.log.info "space: #{space_details}"

        @model  = Model.new(
          name: space_details['name'],
          description: space_details['description'],
          cartogram: space_details['cartogram']['structure']
          # pawn: {
          #   location
          # }
        )
      end

      def render
        @view.draw(@model)
      end

      def press(key)
        @ui.log.info "pressed #{key}"
        if key == 'x' || key == 'q'
          @ui.quit!
        end
      end

      def launch!
        puts "=== SCREEN"
        boot!
        @ui.launch!
      end
    end
  end
end
