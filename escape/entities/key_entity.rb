class KeyEntity < Entity
  attr_accessor :y, :ya, :sprite
  
  COLOR = Art.get_col(0x00ffff)
  
  def initialize(x, z)
    super()
    @x = x
    @z = z
    @y = 0.5
    @ya = 0.025
    @sprite = Sprite.new(0, 0, 0, 16 + 3, COLOR)
  end
  
  def tick
    move
    @y += @ya
    @y = 0 if @y < 0
    @ya -= 0.005
    @sprite.y = @y
  end
  
  def collide(entity)
    return unless entity.is_a?(Player)
    
    Sound::KEY.play
    entity.keys += 1
    remove
  end
end