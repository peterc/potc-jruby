class DoorBlock < Block
  attr_accessor :openness
  
  def initialize
    super
    @tex = 4
    @openness = 0
    @solid_render = false
  end
  
  def use(level, item)
    @open = !@open
    if @open
      Sound::CLICK1.play
    else
      Sound::CLICK2.play
    end
    true
  end
  
  def tick
    super
    
    @openness += @open ? 0.2 : -0.2
    @openness = 0 if @openness < 0
    @openness = 1 if @openness > 1
    
    open_limit = 7 / 8.0
    if @openness < open_limit && !@open && !@blocks_motion
      if @level.contains_blocking_entity(@x - 0.5, @y - 0.5, @x + 0.5, @y + 0.5)
				@openness = open_limit
				return
			end
    end
    
    @blocks_motion = @openness < open_limit
  end
  
  def blocks(entity)
    openLimit = 7 / 8.0
    return @blocks_motion if entity.is_a?(Player) && @openness >= open_limit
    return @blocks_motion if entity.is_a?(Bullet) && @openness >= open_limit
    return @blocks_motion if entity.is_a?(OgreEntity) && @openness >= open_limit
    true
  end  
end