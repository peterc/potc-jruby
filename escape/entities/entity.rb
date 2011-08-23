class Entity
  attr_accessor :x, :z, :rot, :xa, :za, :rota, :r, :flying, :removed, :x_tileo, :z_tileo, :level
  
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
end