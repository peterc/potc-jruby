class Block
  attr_accessor :tex, :col, :id, :x, :y, :level, :sprites, :entities, :floor_tex, :ceil_tex, :floor_col, :ceil_col, :messages
  
  def solid_wall
    SolidBlock.new
  end
  
  def initialize
    @blocks_motion = false
    @solid_render = false
    @messages = []
    @sprites = []
    @entities = []
    @tex = -1
    @col = -1
    @floor_col = -1
    @ceil_col = -1
    @floor_tex = -1
    @ceil_tex = -1
    @id = @x = @y = @level = nil
  end
  
  def add_sprite(sprite)
    @sprites << sprite
  end
  
  def use(level, item)
    false
  end
  
  def tick
    sprites.each do |sprite|
      sprite.tick
      sprites.delete(sprite) if sprite.removed
    end
  end
  
  def remove_entity(entity)
    entities.delete(entity)
  end
  
  def add_entity(entity)
    entities << entity
  end
  
  def blocks(entity)
    @blocks_motion
  end
  
  def decorate(level, x, y); end
  
  def get_floor_height(e)
    0
  end
  
  def get_walk_speed(player)
    1
  end
  
  def get_friction(player)
    0.6
  end
  
  def trigger(pressed); end
end