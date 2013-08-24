class Beatz
  attr_accessor :sound, :status
  def initialize(sound = nil)
    @sound = sound || NullSound.new
    @status = false
  end

  def play
    sound.play if on?
  end

  def on?
    status
  end

  def toggle
    self.status = !status
  end
end
