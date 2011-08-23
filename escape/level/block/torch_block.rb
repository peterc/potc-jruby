class TorchBlock < Block
  def initialize
    super
    @torch_sprite = Sprite.new(0 ,0, 0, 3, Art.get_col(0xffff00))
    @sprites.add @torch_sprite
  end
  
  def decorate(level, x, y)
    r = 0.4
    
    # eugh.. I don't like this at all but I'm just straight porting for now, cleanups later! :-)
    1000.times do |i|
      face = rand(4)
      if face == 0 && level.get_block(x - 1, y).solid_render
        @torch_sprite.x -= r
        break
      end
      if face == 1 && level.get_block(x, y - 1).solid_render
        @torch_sprite.z -= r
        break
      end
      if face == 2 && level.get_block(x + 1, y).solid_render
        @torch_sprite.x += r
        break
      end
      if face == 3 && level.get_block(x, y + 1).solid_render
        @torch_sprite.z += r
        break
      end
    end
  end
  
  def tick
    super
    @torch_sprite.tex = 3 + rand(2) if rand(4) == 0
  end
end