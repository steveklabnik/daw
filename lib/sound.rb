# <3 peterc https://github.com/peterc/potc-jruby/blob/master/escape/sound.rb
require 'java'
java_import javax.sound.sampled.AudioSystem
java_import javax.sound.sampled.Clip
java_import javax.sound.sampled.DataLine


class Sound
  ASSETS_DIR = "#{File.dirname(__FILE__)}/../assets/sounds"
  attr_accessor :url
  
  def self.load_sound(file_name)
    sound = new
    sound.url = java.net.URL.new("file://" + ASSETS_DIR + file_name)
    sound
  end
  
  def play
    if url
      Thread.new do
        ais = AudioSystem.get_audio_input_stream(url)
        info = DataLine::Info.new(Clip.java_class, ais.format)
        clip = AudioSystem.get_line(info)
        clip.open(ais)
        clip.start
      end
    end
  end
  
  %w{bosskill hihatclosed}.each do |name|
    const_set name.upcase, load_sound("/#{name}.wav")
  end
end

class NullSound
  def play
  end
end
