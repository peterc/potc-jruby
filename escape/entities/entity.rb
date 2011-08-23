class Entity
  attr_accessor :x, :z, :r, :rot, :xa, :za, :rota, :r, :flying, :removed, :x_tileo, :z_tileo, :level
  
  def initialize
    @r = 0.4
    @x_tileo = -1
    @z_tileo = -1
    @removed = false
    @flying = false
    @level = nil
  end
  
  def update_pos
    x_tile = (x + 0.5).to_i
    z_tile = (z + 0.5).to_i
    if x_tile != @x_tileo || z_tile != @z_tileo
      @level.get_block(@x_tileo, @z_tileo).remove_entity self
      @x_tileo = x_tile
      @z_tileo = z_tile
      @level.get_block(@x_tileo, @z_tileo).add_entity(self) unless @removed
    end
  end
  
  def is_removed
    @removed
  end
  
  def remove
    @level.get_block(@x_tileo, @z_tileo).remove_entity self
    @removed = true
  end
  
  def move
    x_steps = ((xa * 100).abs + 1).to_i
    x_steps.downto(1) do |i|
      xxa = @xa
      if is_free(x + xxa * i / x_steps, z)
        x += xxa * i / x_steps
        break
      end

      xa = 0
    end
    
    z_steps = ((za * 100).abs + 1).to_i
    z_steps.downto(1) do |i|
      zza = @za
      if is_free(x, z + zza * i / z_steps)
        z += zza * i / z_steps
        break
      end

      za = 0
    end
  end
  
  def is_free(xx, yy)
    # TODO: Pick up here
    
    
    
    
    
    
  end
  
  def collide(entity); end
  
  def blocks(entity, x2, z2, r2)
    return false if entity.is_a?(Bullet) && entity.owner == self  
    
    # TODO: Can be tightened down to a single expression!
    return false if @x + @r <= x2 - r2
		return false if @x - @r >= x2 + r2
		return false if @z + @r <= z2 - r2
		return false if @z - @r >= z2 + r2
    
		true    
  end
  
  def contains(x2, z2)
    # TODO: Can be tightened down to a single expression!
    return false if @x + @r <= x2
		return false if @x - @r >= x2
		return false if @z + @r <= z2
		return false if @z - @r >= z2
    
		true
  end
  
  def is_inside(x0, z0, x1, z1)
    # TODO: Can be tightened down to a single expression!
    return false if @x + @r <= x0
		return false if @x - @r >= x1
		return false if @z + @r <= z0
		return false if @z - @r >= z1
    
		true
  end
  
  def use(source, item)
    false
  end
  
  def tick; end
end