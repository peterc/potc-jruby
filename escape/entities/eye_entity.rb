class EyeEntity < EnemyEntity
  def initialize(x, z)
    super(x, z, 4 * 8 + 4, Art.get_col(0x84ECFF)
    @health = 4
    @r = 0.3
    @run_speed = 2
    @spin_speed *= 1.5
    @flying = true
  end
end