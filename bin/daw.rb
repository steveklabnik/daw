$:.unshift("#{File.dirname(__FILE__)}/../lib")
require 'sound'

Shoes.app do
  fill black 

  @sounds = [
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
    [NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new, NullSound.new], 
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
  @beatz_onoff = [
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
    [false, false, false, false, false, false, false, false], 
  ]
  (0..7).each do |w|
    (0..7).each do |h|
      @beatz_array[w][h] = rect(top: top_offset + (h * 50), left: left_offset + (w * 50), width: 50, height: 50, fill: black, stroke: gray)
      @beatz_array[w][h].click do
        if @beatz_onoff[w][h]
          @beatz_array[w][h].style(fill: black, stroke: gray)
          @sounds[w][h] = NullSound.new
        else
          @beatz_array[w][h].style(fill: yellow, stroke: black)
          @sounds[w][h] = Sound::HIHATCLOSED
        end
        @beatz_onoff[w][h] = !@beatz_onoff[w][h]
      end
    end
  end

  stack do
    @count = -1
    @on = false

    button "start" do
      @on = true
    end


    @cursor = rect(top: 0, left: 50, width: 50, height: 50, fill: yellow)
    @cursor.hide

    @loop = every(0.5) do |t|
      @count += 1 if @on
      puts @count
      if @count == 8
        @on = false
        @count = -1
        @cursor.left = 50
        @cursor.hide
      elsif @count != -1
        if @count == 0
          @cursor.show
        else
          @cursor.left = @cursor.left + 50
        end
        @sounds[@count].each_with_index do |s, i|
          puts "playing #@count #{i}: #{s.class}"
          s.play
        end
      end
    end

  end
end
