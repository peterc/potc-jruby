class PoofSprite < Sprite
  def initialize(x, y, z)
    super(x, y, z, 5, 0x222222)
    @life = 20
  end
  
  def tick
    @life -= 1
    @removed = true if life <= 0
  end
end