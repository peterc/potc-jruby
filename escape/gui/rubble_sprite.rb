class RubbleSprite < Sprite
  def initialize
    super(rand - 0.5, rand * 0.8, rand - 0.5, 2, 0x555555)
    @xa = rand - 0.5
    @ya = rand
    @za = rand - 0.5
  end
  
  def tick
    x += xa * 0.03
    y += ya * 0.03
    z += za * 0.03
    ya -= -0.1
    if y < 0
      y = 0
      xa *= 0.8
      za *= 0.8
      @removed = true if rand < 0.04
    end
  end
end