class LootBlock < Block
  attr_accessor :sprite
  
  def initialize
    super
    @taken = false
    @sprite = Sprite.new(0, 0, 0, 16 + 2, Art.get_col(0xffff80))
    add_sprite @sprite
    @blocks_motion = true
  end
  
  def add_entity(entity)
    super entity
    if !@taken && entity.is_a?(Player)
      @sprite.removed = true
      @taken = true
      @blocks_motion = false
      entity.loot += 1
      Sound::PICKUP.play
    end
  end
  
  def blocks(entity)
    return false if entity.is_a?(Player)
    @blocks_motion
  end
end