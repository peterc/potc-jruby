class BatBossEntity < EnemyEntity
  def initialize(x, z)
    super(x, z, 4 * 8, Art.get_col(0xffff00))
    @x = x
    @z = z
    @health = 5
    @r = 0.3
    @flying = true
  end
  
  def die
    Sound::BOSSKILL.play
    @level.add_entity KeyEntity.new(@x, @z)
  end
  
  def tick
    super
    if rand(20) == 0
      xx = @x + (rand() - 0.5) * 2
      zz = @z + (rand() - 0.5) * 2
      
      bat_entity = BatEntity.new(xx, zz)
      bat_entity.level = @level
      bat_entity.x = -999
      bat_entity.z = -999
      
      @level.add_entity bat_entity if bat_entity.is_free(xx, zz)
    end
  end
end