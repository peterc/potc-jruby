class PressurePlateBlock < Block
  attr_accessor :pressed
  
  def initialize
    super
    @floor_tex = 2
    @pressed = false
  end
  
  def tick
    super
    r = 0.2
    stepped_on = @level.contains_blocking_non_flying_entity(@x - r, @y - r, @x + r, @y + r)
    if stepped_on != @pressed
      @pressed = stepped_on
      @floor_tex = @pressed ? 3 : 2
      @level.trigger(@id, @pressed)
      if @pressed
        Sound::CLICK1.play
      else
        Sound::CLICK2.play
      end
    end
  end
  
  def get_floor_height(e)
    @pressed ? -0.02 : 0.02
  end  
end