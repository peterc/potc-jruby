class WaterBlock < Block
  def initialize
    super
    @blocks_motion = true
  end
  
  def tick
    super
    @steps -= 1
    if @steps <= 0
      @floor_text = 8 + rand(3)
      @floor_col = Art.get_col(0x0000ff)
      @steps = 16
    end
  end
  
  def blocks(entity)
    return false if entity.is_a?(Player) && entity.get_selected_item == Item::FLIPPERS
    return false if entity.is_a?(Bullet)
    @blocks_motion
  end  
  
  def get_floor_height(e)
    -0.5
  end
  
  def get_walk_speed(player)
    0.4
  end
end