# encoding: UTF-8
$:.unshift("#{File.dirname(__FILE__)}/../lib")

require 'sound'
require 'beatz'

Shoes.app width: 500 do

  # The list of all of the sounds in our DAW. Starts off with just blank ones.
  #
  # FIXME: Load up the correct songs on initialization, rather than when the
  # button is clicked.
  @sounds = [
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
    [Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new, Beatz.new], 
  ]

  # This is the list of all of the rectangles. We need this to be separate, because
  # we have to access them independently to toggle their style.
  #
  # FIXME: move this into Beatz. Requires passing around references to the app.
  @beatz_array = [
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
  ]

  # Generate all the squares.
  #
  # FIXME: Move this into some sort of factory method. Requires passing around
  # references to the app.
  left_offset = 50
  top_offset = 50
  (0..7).each do |w|
    (0..7).each do |h|
      @beatz_array[w][h] = rect(top: top_offset + (h * 50),
                                left: left_offset + (w * 50),
                                width: 50,
                                height: 50,
                                fill: black,
                                stroke: gray)
      @beatz_array[w][h].click do
        if @sounds[w][h].on?
          @beatz_array[w][h].style(fill: black, stroke: gray)
          @sounds[w][h] = Beatz.new
        else
          @beatz_array[w][h].style(fill: yellow, stroke: black)
          @sounds[w][h] = Beatz.new(Sound.const_get("SOUND_#{w + 1}"))
          @sounds[w][h].toggle
        end
      end
    end
  end

  stack do

    # This keeps track of the current 'frame' we're on. -1 means we're not
    # currently doing anything.
    @count = -1

    # Are we playing, or not? Should be the same as `!(@count == -1)`, but this
    # is a bit more intention-revealing.
    @on = false

    # The button that gets our music started!
    @start = button "start" do
      @on = true
    end

    # A checkbox to allow us to loop forever.
    flow do
      @will_loop = check
      para "🔁"
    end

    # The 'cursor' block at the top, to show our progression through the beatz.
    @cursor = rect(top: 0, left: 50, width: 50, height: 50, fill: yellow)
    @cursor.hide

    # This is where most of the magic happens, the main loop.
    @loop = every(0.5) do |t|
      @count += 1 if @on

      if @count == 8
        @cursor.left = 50

        if @will_loop.checked?
          @count = 0
        else
          @on = false
          @count = -1
          @cursor.hide
        end
      elsif @count != -1
        if @count == 0
          @cursor.show
        else
          @cursor.left = @cursor.left + 50
        end
        @sounds[@count].each_with_index do |s, i|
          s.play
        end
      end
    end
  end
end
