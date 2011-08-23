class Bitmap3D < Bitmap
  attr_accessor :z_buffer, :z_buffer_wall, :x_cam, :y_cam, :z_cam, :r_cos, :r_sin, :fov, :x_center, :y_center, :rot
  
  def initialize(width, height)
    super(width, height)
    
    @z_buffer = Array.new(width * height, 0.0)
    @z_buffer_wall = Array.new(width, 0.0)
  end
  
  def render(game)
    @z_buffer_wall.fill(0.0)
    @z_buffer.fill(10000)
    
    @rot = game.player.rot
    @x_cam = game.player.x - Math.sin(@rot) * 0.3
    @y_cam = game.player.z - Math.cos(@rot) * 0.3
    @z_cam = -0.2 + Math.sin(game.player.bob_phase * 0.4) * 0.01 * game.player.bob - game.player.y
    
    @x_center = @width / 2.0
    @y_center = @height / 3.0
    
    @r_cos = Math.cos(@rot)
    @r_sin = Math.sin(@rot)
    
    @fov = @height
    
    level = game.level
    r = 6
    
    x_center = @x_cam.floor
    z_center = @y_cam.floor
    
    (z_center - r).upto(z_center + r) do |zb|
			(x_center - r).upto(x_center + r) do |xb|
				c = level.get_block(xb, zb)
				e = level.get_block(xb + 1, zb)
				s = level.get_block(xb, zb + 1)

				if c.is_a?(DoorBlock)
					rr = 1 / 8.0
					openness = 1 - c.openness * 7 / 8
					if e.solid_render
						render_wall(xb + openness, zb + 0.5 - rr, xb, zb + 0.5 - rr, c.tex, (c.col & 0xfefefe) >> 1, 0, openness)
						render_wall(xb, zb + 0.5 + rr, xb + openness, zb + 0.5 + rr, c.tex, (c.col & 0xfefefe) >> 1, openness, 0)
						render_wall(xb + openness, zb + 0.5 + rr, xb + openness, zb + 0.5 - rr, c.tex, c.col, 0.5 - rr, 0.5 + rr)
					else
						render_wall(xb + 0.5 - rr, zb, xb + 0.5 - rr, zb + openness, c.tex, c.col, openness, 0)
						render_wall(xb + 0.5 + rr, zb + openness, xb + 0.5 + rr, zb, c.tex, c.col, 0, openness)
						render_wall(xb + 0.5 - rr, zb + openness, xb + 0.5 + rr, zb + openness, c.tex, (c.col & 0xfefefe) >> 1, 0.5 - rr, 0.5 + rr)
					end
				end

				if c.solid_render
					render_wall(xb + 1, zb + 1, xb + 1, zb, c.tex, c.col) if !e.solid_render
					render_wall(xb, zb + 1, xb + 1, zb + 1, c.tex, (c.col & 0xfefefe) >> 1) if !s.solid_render
				else
					render_wall(xb + 1, zb, xb + 1, zb + 1, e.tex, e.col) if e.solid_render
					render_wall(xb + 1, zb + 1, xb, zb + 1, s.tex, (s.col & 0xfefefe) >> 1) if s.solid_render
        end
			end
		end
		
		(zCenter - r).upto(zCenter + r) do |zb|
			(xCenter - r).upto(xCenter + r) do |xb|
				c = level.get_block(xb, zb)
    
				c.entities.each do |e|
					e.sprites.each do |sprite|
						render_sprite(e.x + sprite.x, 0 - sprite.y, e.z + sprite.z, sprite.tex, sprite.col)
					end
				end
    
				sprites.each do |sprite|
					render_sprite(xb + sprite.x, 0 - sprite.y, zb + sprite.z, sprite.tex, sprite.col)
				end
			end
		end

		render_floor level
  end
  
  def render_floor(level)
  end
  
  def post_process(level)
    # TODO
  end
end