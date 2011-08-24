class PitBlock < Block
  def initialize
    super
    @filled = false
    @floor_tex = 1
    @blocks_motion = true
  end
  
  def add_entity(entity)
    super
    return unless !@filled && entity.is_a?(BoulderEntity)
    entity.remove
    @filled = true
    @blocks_motion = false
    add_sprite Sprite.new(0, 0, 0, 8 + 2, BoulderEntity::COLOR)
    Sound::THUD.play
  end
  
  def blocks(entity)
    entity.is_a?(BoulderEntity) ? false : @blocks_motion
  end
end