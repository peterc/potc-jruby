class Sprite
  attr_accessor :removed, :x, :y, :z, :tex, :col
  
  def initialize(x, y, z, tex, color)
    @x = x
    @y = y
    @z = z
    @tex = tex
    @col = color || 0x202020
    @removed = false
  end
  
  def tick; end
end