class EnemyEntity < Entity
  attr_accessor :sprite, :default_tex, :default_color, :hurt_time, :anim_time, :health, :spin_speed, :run_speed
  
  def initialize(x, z, default_tex, default_color)
    super()
    @hurt_time = 0
    @anim_time = 0
    @health = 3
    @spin_speed = 0.1
    @run_speed = 1
    @x = x
    @z = z
    @default_tex = default_tex
    @default_color = default_color
    @sprite = Sprite.new(0, 0, 0, 4 * 8, default_color)
    @sprites << @sprite
    @r = 0.3
  end
  
  def tick
    if @hurt_time > 0
			@hurt_time -= 1
			@sprite.col = @default_color if @hurt_time == 0
    end
		@anim_time += 1
		@sprite.tex = @default_tex + @anim_time / 10 % 2
		move
		@rota += (rand * rand) * 0.3 if @xa == 0 || @za == 0

		@rota += (rand * rand) * @spin_speed
		@rot += @rota
		@rota *= 0.8
		@xa *= 0.8
		@za *= 0.8
		
		@xa += Math.sin(@rot) * 0.004 * @run_speed
		@za += Math.cos(@rot) * 0.004 * @run_speed
  end
  
  def use(source, item)
    return false if @hurt_time > 0
    return false if item != Item::POWER_GLOVE
    
    hurt(Math.sin(source.rot), Math.cos(source.rot))
    
    true
  end
  
  def hurt(xd, zd)
    @sprite.col = Art.get_col(0xff0000)
    @hurt_time = 15
    
    dd = Math.sqrt(xd * xd + zd * zd)
    @xa += xd / dd * 0.2
    @za += zd / dd * 0.2
    Sound::HURT2.play
    @health -= 1
    if @health <= 0
      xt = (@x + 0.5).to_i
      zt = (@z + 0.5).to_i
      @level.get_block(xt, zt).add_sprite(PoofSprite.new(@x - xt, 0, @z - zt))
      die
      remove
      Sound::KILL.play
    end
  end
  
  def die; end
  
  def collide(entity)
    if entity.is_a?(Bullet)
      bullet = entity
      return if bullet.owner.class == self.class
      return if @hurt_time > 0
      entity.remove
      hurt(entity.xa, entity.za)
    end
    if entity.is_a?(Player)
      entity.hurt(self, 1)
    end
  end
end