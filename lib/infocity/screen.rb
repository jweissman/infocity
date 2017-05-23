module Infocity
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
      label = Swearing::Label.new(x: 2, y: 3, text: "NAME: #{model.name} | DESCRIPTION: #{model.description}")
      label.draw

      grid = Swearing::Grid.new(
        x: 0, y: 0,
        legend: { 0 => ' ', 1 => '.', 2 => '_', 3 => '|' },
        field: model.cartogram
      )

      container = Swearing::Container.new(width: cols, height: lines, elements: [ grid ] )
      container.draw
    end
  end

  class Screen
    def initialize
      @view   = View.new
      @client = Client.new

      @ui = Swearing::UI.new(
        keypress: method(:press),
        view: method(:render)
      )

      @client.connect!
      space_details = @client.retrieve_space_details

      @ui.log.info "space: #{space_details}"
      @model  = Model.new(
        name: space_details['name'],
        description: space_details['description'],
        cartogram: space_details['cartogram']['structure']
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
      @ui.launch!
    end
  end
end
