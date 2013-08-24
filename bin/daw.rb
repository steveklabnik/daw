# encoding: UTF-8
$:.unshift("#{File.dirname(__FILE__)}/../lib")
require 'sound'
require 'beatz'

Shoes.app width: 500 do
  fill black 

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
  left_offset = 50
  top_offset = 50
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
  (0..7).each do |w|
    (0..7).each do |h|
      @beatz_array[w][h] = rect(top: top_offset + (h * 50), left: left_offset + (w * 50), width: 50, height: 50, fill: black, stroke: gray)
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
    @count = -1
    @on = false

    @start = button "start" do
      @on = true
    end
    flow do
      @will_loop = check
      para "🔁"
    end

    @cursor = rect(top: 0, left: 50, width: 50, height: 50, fill: yellow)
    @cursor.hide

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
