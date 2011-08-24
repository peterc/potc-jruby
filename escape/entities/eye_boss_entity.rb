class EyeBossEntity < EnemyEntity
  def initialize(x, z)
    super(x, z, 4 * 8 + 4, Art.get_col(0xFFFF00))
    @health = 10
    @r = 0.3
    @run_speed = 4
    @spin_speed *= 1.5
    @flying = true
  end
  
  def die
    Sound::BOSSKILL.play
    @level.add_entity KeyEntity.new(@x, @z)
  end
end