class VanishBlock < SolidBlock
  def initialize
    super
    @tex = 1
  end
  
  def use(level, item)
    return false if @gone
    
    @gone = true
    @blocks_motion = false
    @solid_render = false
    Sound::CRUMBLE.play
    
    32.times do |i|
      sprite = RubbleSprite.new
      sprite.col = @col
      add_sprite sprite
    end
    
    true
  end
end