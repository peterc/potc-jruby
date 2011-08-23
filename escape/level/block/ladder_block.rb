class LadderBlock < Block
  attr_accessor :wait
  
  LADDER_COLOR = 0xDB8E53
  
  def initialize(down)
    super()
    
    @wait = false

    if down
      @floor_tex = 1
      add_sprite Sprite.new(0, 0, 0, 8 + 3, Art.get_col(LADDER_COLOR))
    else
      @ceil_tex = 1
      add_sprite Sprite.new(0, 0, 0, 8 + 4, Art.get_col(LADDER_COLOR))
    end    
  end
  
  def remove_entity(entity)
    super
    @wait = false if entity.is_a?(Player)
  end
  
  def add_entity(entity)
    super
    if !@wait && entity.is_a?(Player)
      @level.switch_level(@id)
      Sound::LADDER.play
    end
  end
end