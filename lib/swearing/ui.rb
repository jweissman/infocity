require 'logger'
require 'curses'

# a little wrapper around curses
module Swearing
  class Component
    include Curses

    def log
      @logger = Logger.new('log/swearing.log')
    end

    def inscribe(figure: 'X', at:)
      x, y = *at
      setpos(y, x)
      addstr(figure)
    end
  end

  class Label < Component
    def initialize(x:, y:, text:)
      @x, @y, @text = x, y, text
    end

    def draw(offset: [0,0])
      ox, oy = *offset
      inscribe figure: @text, at: [@x + ox, @y + oy]
    end
  end

  # a labelled inscription
  class Sigil < Swearing::Component
    def initialize(x:, y:, figure:, text:)
      @x, @y, @figure, @text = x, y, figure, text
    end

    def draw(offset: [0,0])
      ox, oy = *offset
      inscribe figure: @figure, at: [@x + ox, @y + oy]
      inscribe figure: @text,   at: [@x + ox - @text.length/2, @y + oy + 1]
    end
  end

  class Grid < Component
    attr_accessor :x, :y
    def initialize(x:, y:, field:, legend:)
      @x, @y, @field = x, y, field
      @legend = legend
      @marks = []
    end

    def show(mark)
      @marks << mark
    end

    def figure_at(px,py)
      @legend[value_at(px,py)]
    end

    def value_at(px,py)
      @field[py][px]
    end

    def width
      @field[0].length
    end

    def height
      @field.length
    end

    def each_position
      (0...width).each do |xi|
        (0...height).each do |yi|
          yield [xi,yi]
        end
      end
    end

    def draw
      each_position do |(xi,yi)|
        figure = figure_at(xi, yi)
        position = [ @x + xi, @y + yi ]
        inscribe figure: figure, at: position
      end

      @marks.each do |mark|
        mark.draw(offset: [@x, @y])
        # inscribe figure: mark.text, at: [ @x + mark.x, @y + mark.y]
      end
    end
  end

  class Container < Component
    def initialize(elements:, width:, height:, x: 0, y: 0)
      @elements = elements
      @x, @y, @width, @height = x, y, width, height
    end

    def draw
      begin
        cx, cy = @width/2, @height/2
        @elements.each do |element|
          translated_element = element.dup
          translated_element.x += (cx - translated_element.width/2)
          translated_element.y += (cy - translated_element.height/2)
          translated_element.draw
        end
      rescue
        log.error $!
      end
    end
  end

  class UI
    include Curses

    def initialize(keypress:, view:)
      @keypress_handler = keypress
      @render_view = view
    end

    def draw
      @render_view.call
      true
    end

    def launch!
      @ui = ui_core_thread
      @refresh = refresh_loop_thread
      [ @ui, @refresh ].map(&:join)
    end

    def quit?
      @quit ||= false
    end

    def quit!
      # EventMachine.stop
      @quit = true
    end

    def log
      @logger ||= Logger.new('log/screen.log')
    end

    protected
    def wait_for_keypress
      log.info "WAIT FOR KEYPRESS!!!!"
      @keypress_handler.call(getch)
    end

    private
    def refresh_loop_thread
      Thread.new do
        until quit?
          begin
            clear
            draw
            refresh
            sleep 0.1
          rescue
            log.error $!
          end
        end
      end
    end

    def ui_core_thread
      Thread.new do
        begin
          noecho
          init_screen
          wait_for_keypress until quit?
        rescue
          log.error $!
        ensure
          close_screen
        end
      end
    end
  end
end
