class BarsBlock < Block
  def initialize
    super
    @sprite = Sprite.new(0, 0, 0, 0, 0x202020)
    add_sprite @sprite
    @blocks_motion = true
    @open = false
  end
  
  def use(level, item)
    return false if @open
    
    if item == Item::CUTTERS
      Sound::CUT.play
      @sprite.tex = 1
      @open = true
    end
    
    true
  end
  
  def blocks(entity)
    return false if @open && entity.is_a?(Player)
    return false if @open && entity.is_a?(Bullet)
    @blocks_motion
  end
end