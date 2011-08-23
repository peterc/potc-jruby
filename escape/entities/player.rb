class Player < Entity
  attr_accessor :bob, :bob_phase, :turn_bob, :selected_slot, :item_use_time, :y, :ya, :hurt_time, :health, :keys, :loot, :dead, :dead_time, :ammo, :potions, :last_block, :sliding
  
  def initialize
    super
    @selected_slot = 0
    @hurt_time = 0
    @health = 20
    @keys = 0
    @loot = 0
    @dead = false
    @dead_time = 0
    @ammo = 0
    @potions = 0
    @r = 0.3
    @y = 0.0
    @bob = @bob_phase = @turn_bob = 0.0
    @ya = 0.0
    @time = 0
    @item_use_time = 0
    @sliding = false
    @items = Array.new(8) { Item::NONE }
  end
  
  def tick(up, down, left, right, turn_left, turn_right)
    if @dead
      up = down = left = right = turn_left = turn_right = false
      @dead_time += 1
      @level.lose if @dead_time > 60 * 2
    else
      @time += 1
    end
    
    @item_use_time -= 1 if @item_use_time > 0
    @hurt_time -= 1 if @hurt_time > 0
    
    on_block = @level.get_block((x + 0.5).to_i, (z + 0.5).to_i)
    fh = on_block.get_floor_height self
    Sound::SPLASH.play if on_block.is_a?(WaterBlock) && !@last_block.is_a?(WaterBlock)
    @last_block = on_block
    
    fh -= 0.6 if @dead
    
    if fh > @y
      @y += (fh - y) * 0.2
      @ya = 0
    else
      @ya -= 0.01
      @y += @ya
      if @y < fh
        @y = fh
        @ya = 0
      end
    end
    
    rot_speed = 0.05
    walk_speed = 0.03 * on_block.get_walk_speed(self)
    
    @rota += rot_speed if turn_left
    @rota -= rot_speed if turn_right
    
    xm = 0
    zm = 0
    zm -= 1 if up
    zm += 1 if down
    xm -= 1 if left
    xm += 1 if right
    dd = xm * xm + zm * zm
    dd = dd > 0 ? Math.sqrt(dd) : 1
    xm /= dd
    zm /= dd
    
    @bob *= 0.6
    @turn_bob *= 0.8
    @turn_bob += @rota
    @bob += Math.sqrt(xm * xm + zm * zm)
    @bob_phase += Math.sqrt(xm * xm + zm * zm) * on_block.get_walk_speed(self)
    was_sliding = @sliding
    @sliding = false
    
    if on_block.is_a?(IceBlock) && get_selected_item != Item::SKATES
			if @xa * @xa > @za * @za
				@sliding = true
				@za = 0
				@xa = @xa > 0 ? 0.08 : -0.08
				@z += ((@z + 0.5).to_i - @z) * 0.2
			elsif @xa * @xa < @za * @za
				@sliding = true
				@xa = 0
				@za = @za > 0 ? 0.08 : -0.08
				@x += ((@x + 0.5).to_i - @x) * 0.2
			else
				@xa -= (xm * Math.cos(@rot) + zm * Math.sin(@rot)) * 0.1
				@za -= (zm * Math.cos(@rot) - xm * Math.sin(@rot)) * 0.1
			end

			Sound::SLIDE.play if !was_sliding && @sliding
		else
			@xa -= (xm * Math.cos(@rot) + zm * Math.sin(@rot)) * walk_speed
			@za -= (zm * Math.cos(@rot) - xm * Math.sin(@rot)) * walk_speed
		end

		move

		friction = on_block.get_friction self
		@xa *= friction
		@za *= friction
		@rot += @rota
		@rota *= 0.4
  end
  
  def activate
		return if @dead
		return if @item_use_time > 0
		item = @items[@selected_slot]
		
		if item == Item::PISTOL
			if @ammo > 0
				Sound::SHOOT.play
				@item_use_time = 10
				@level.add_entity Bullet.new(self, @x, @z, @rot, 1, 0, 0xffffff)
				@ammo -= 1
			end
			return
		end
		
		if item == Item::POTION
			if @potions > 0 && @health < 20
				Sound::POTION.play
				@item_use_time = 20
				@health += 5 + rand(6)
				@health = 20 if @health > 20
				@potions -= 1
			end
			return
		end
		
		@item_use_time = 10 if item == Item::KEY || item == Item::POWER_GLOVE || item == Item::CUTTERS

		xa = 2 * Math.sin(@rot)
		za = 2 * Math.cos(@rot)

		rr = 3
		xc = (x + 0.5).to_i
		zc = (z + 0.5).to_i
		
		possible_hits = []
		
		(zc - rr).upto(zc + rr) do |z|
			(xc - rr).upto(xc + rr) do |x|
				@level.get_block(x, z).entities.each do |e|
					possible_hits << e unless e == self
				end
			end
		end

    divs = 100
		divs.times do |i|
			xx = @x + @xa * i / divs
			zz = @z + @za * i / divs
			possible_hits.each { |e| return if e.contains(xx, zz) && e.use(self, @items[@selected_slot]) }
			xt = (xx + 0.5).to_i
			zt = (zz + 0.5).to_i
			if xt != (@x + 0.5).to_i || zt != (@z + 0.5).to_i
				block = @level.get_block(xt, zt)
				return if block.use(level, @items[@selected_slot])
				return if block.blocks(self)
			end
		end
	end
  
  #def blocks(entity, x2, z2, r2)
  #  super(entity, x2, z2, r2)
  #end
  
  def get_selected_item
    @items[@selected_slot]
  end
  
  def add_loot(item)
    @ammo += 20 if item == Item::PISTOL
    @potions += 1 if item == Item::POTION
    
    @items.each do |my_item|
      if my_item == item
        @level.show_loot_screen(item) if @level
        return
      end
    end
    
    @items.each_with_index do |my_item, i|
      if my_item == Item::NONE
        @items[i] = item
        @selected_slot = 1
        @item_use_time = 0
        @level.show_loot_screen(item) if @level
        return
      end
    end
  end
  
  def hurt(enemy, dmg)
    return if @hurt_time > 0 || @dead
    
    @hurt_time = 40
    @health -= dmg
    
    if @health <= 0
      @health = 0
      Sound::DEATH.play
      @dead = true
    end
    
    Sound::HURT.play
    
    xd = enemy.x - @x
    zd = enemy.z - @z
    dd = Math.sqrt(xd * xd + zd * zd)
    @xa -= xd / dd * 0.1
    @za -= zd / dd * 0.1
    @rota += (rand - 0.5) * 0.2
  end
  
  def collide(entity)
    if entity.is_a?(Bullet)
      bullet = entity
      return if bullet.owner.class == self.class
      return if @hurt_time > 0
      entity.remove
      hurt(entity, 1)
    end
  end
  
  def win
    @level.win
  end
end