class BatEntity < EnemyEntity
  def initialize(x, z)
    super(x, z, 4 * 8, Art.get_col(0x82666e))
    @x = x
    @z = z
    @health = 2
    @r = 0.3
    @flying = true
  end    
end