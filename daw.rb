# <3 peterc https://github.com/peterc/potc-jruby/blob/master/escape/sound.rb
require 'java'
require 'jruby/synchronized'
java_import javax.sound.sampled.AudioSystem
java_import javax.sound.sampled.Clip
java_import javax.sound.sampled.DataLine

ASSETS_DIR = File.dirname(__FILE__)

class Sound
  attr_accessor :clip
  
  def self.load_sound(file_name)
    sound = new
    
    url = java.net.URL.new("file://" + ASSETS_DIR + file_name) # nasty little hack due to borked get_resource (means applet won't be easy..)
    ais = AudioSystem.get_audio_input_stream(url)
    info = DataLine::Info.new(Clip.java_class, ais.format)
    clip = AudioSystem.get_line(info)
    clip.open(ais)
    clip.extend JRuby::Synchronized
    sound.clip = clip
    
    sound
  end
  
  def play
    if clip
      Thread.new do
        clip.stop
        clip.frame_position = 0
        clip.start
      end
    end
  end
  
  %w{bosskill}.each do |name|
    const_set name.upcase, load_sound("/#{name}.wav")
  end
end

class NullSound
  def play
  end
end
Shoes.app do
  stroke blue
  strokewidth 4
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
  @rect = rect(top: 50, left: 50, width: 50, height: 50)
  @rect.click do
    @sounds[0][0] = Sound::BOSSKILL.dup
    puts "on"
  end
  @rect = rect(top: 50, left: 100, width: 50, height: 50)
  @rect.click do
    @sounds[1][0] = Sound::BOSSKILL.dup
    puts "on"
  end
  @rect = rect(top: 50, left: 150, width: 50, height: 50)
  @rect.click do
    @sounds[2][0] = Sound::BOSSKILL.dup
    puts "on"
  end
  @rect = rect(top: 50, left: 200, width: 50, height: 50)
  @rect.click do
    @sounds[3][0] = Sound::BOSSKILL.dup
    puts "on"
  end

  stack do
    @count = -1
    @on = false

    button "start" do
      @on = true
    end

    @loop = every(1) do |t|
      @count += 1 if @on
      puts @count
      if @count == 8
        @on = false
        @count = -1
      elsif @count != -1
        @sounds[@count].each do |s|
          puts "playing #{s.class}"
          s.play
        end
      end
    end

  end
end
