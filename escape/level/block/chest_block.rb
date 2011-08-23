class ChestBlock < Block
  attr_accessor :sprite
  
  def initialize
    super
    @tex = 1
    @blocks_motion = true
    @open = false
    
    @sprite = Sprite.new(0, 0, 0, 8 * 2, Art.get_col(0xffff00))
    add_sprite @sprite
  end
  
  def use(level, item)
    return false if @open
    
    @sprite.tex += 1
    @open = true
    
    level.get_loot id
    Sound::TREASURE.play
    
    true    
  end
end