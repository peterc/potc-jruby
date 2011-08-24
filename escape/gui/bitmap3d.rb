class Bitmap3D < Bitmap
  attr_accessor :z_buffer, :z_buffer_wall, :x_cam, :y_cam, :z_cam, :r_cos, :r_sin, :fov, :x_center, :y_center, :rot
  
  def initialize(width, height)
    super(width, height)    
  end
  
  def render(game)
    @z_buffer = Array.new(width * height, 10000)
    @z_buffer_wall = Array.new(width, 0.0)
    
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
    
    zb, max_zb = (z_center - r), (z_center + r)
    while zb <= max_zb
      xb, max_xb = (x_center - r), (x_center + r)
      while xb <= max_xb
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
        xb += 1
			end
      zb += 1
		end
    
    zb, max_zb = (z_center - r), (z_center + r)
    while zb <= max_zb
      xb, max_xb = (x_center - r), (x_center + r)
      while xb <= max_xb
				c = level.get_block(xb, zb)
    
				c.entities.each do |e|
					e.sprites.each do |sprite|
						render_sprite(e.x + sprite.x, 0 - sprite.y, e.z + sprite.z, sprite.tex, sprite.col)
					end
				end
    
				c.sprites.each do |sprite|
					render_sprite(xb + sprite.x, 0 - sprite.y, zb + sprite.z, sprite.tex, sprite.col)
				end
        xb += 1
			end
      zb += 1
		end

		render_floor level
  end
    
  def render_wall(x0, y0, x1, y1, tex, color, xt0 = 0, xt1 = 1)
    xc0 = ((x0 - 0.5) - @x_cam) * 2
    yc0 = ((y0 - 0.5) - @y_cam) * 2

    xx0 = xc0 * @r_cos - yc0 * @r_sin
    u0 = ((-0.5) - @z_cam) * 2
    l0 = ((+0.5) - @z_cam) * 2
    zz0 = yc0 * @r_cos + xc0 * @r_sin

    xc1 = ((x1 - 0.5) - @x_cam) * 2
    yc1 = ((y1 - 0.5) - @y_cam) * 2

    xx1 = xc1 * @r_cos - yc1 * @r_sin
    u1 = ((-0.5) - @z_cam) * 2
    l1 = ((+0.5) - @z_cam) * 2
    zz1 = yc1 * @r_cos + xc1 * @r_sin

    xt0 *= 16
    xt1 *= 16

    z_clip = 0.2

    return if zz0 < z_clip && zz1 < z_clip

    if (zz0 < z_clip)
    	p = (z_clip - zz0) / (zz1 - zz0)
    	zz0 = zz0 + (zz1 - zz0) * p
    	xx0 = xx0 + (xx1 - xx0) * p
    	xt0 = xt0 + (xt1 - xt0) * p
    end

    if (zz1 < z_clip)
    	p = (z_clip - zz0) / (zz1 - zz0)
    	zz1 = zz0 + (zz1 - zz0) * p
    	xx1 = xx0 + (xx1 - xx0) * p
    	xt1 = xt0 + (xt1 - xt0) * p
    end

    x_pixel0 = @x_center - (xx0 / zz0 * fov)
    x_pixel1 = @x_center - (xx1 / zz1 * fov)

    return if x_pixel0 >= x_pixel1
    xp0 = x_pixel0.ceil
    xp1 = x_pixel1.ceil
    xp0 = 0 if xp0 < 0
    xp1 = @width if xp1 > @width

    y_pixel00 = u0 / zz0 * fov + @y_center
    y_pixel01 = l0 / zz0 * fov + @y_center
    y_pixel10 = u1 / zz1 * fov + @y_center
    y_pixel11 = l1 / zz1 * fov + @y_center

    iz0 = 1 / zz0
    iz1 = 1 / zz1

    iza = iz1 - iz0

    ixt0 = xt0 * iz0
    ixta = xt1 * iz1 - ixt0
    iw = 1 / (x_pixel1 - x_pixel0)

    x, max_x = xp0, xp1 - 1
    while x <= max_x
    	pr = (x - x_pixel0) * iw
    	iz = iz0 + iza * pr

    	next(x += 1) if @z_buffer_wall[x] > iz
    	@z_buffer_wall[x] = iz
    	x_tex = ((ixt0 + ixta * pr) / iz).to_i

    	y_pixel0 = y_pixel00 + (y_pixel10 - y_pixel00) * pr - 0.5
    	y_pixel1 = y_pixel01 + (y_pixel11 - y_pixel01) * pr

    	yp0 = y_pixel0.ceil
    	yp1 = y_pixel1.ceil
    	yp0 = 0 if yp0 < 0
    	yp1 = @height if yp1 > @height

    	ih = 1 / (y_pixel1 - y_pixel0)

      y, max_y = yp0, yp1 - 1
      while y <= max_y
    		pry = (y - y_pixel0) * ih
    		y_tex = (16 * pry).to_i
    		@pixels[x + y * @width] = (Art::WALLS.pixels[((x_tex) + (tex % 8) * 16) + (y_tex + tex / 8 * 16) * 128] * color)
    		@z_buffer[x + y * @width] = 1 / iz * 4
        y += 1
    	end
      x += 1
    end
  end
  
  def render_floor(level)
    y, max_y = 0, @height
    while y < max_y
			yd = ((y + 0.5) - @y_center) / @fov

			floor = true
			zd = (4 - @z_cam * 8) / yd
			if yd < 0
				floor = false
				zd = (4 + @z_cam * 8) / -yd
			end

      x, max_x = 0, @width
      while x < max_x
				next(x += 1) if @z_buffer[x + y * @width] <= zd

				xd = (@x_center - x) / fov
				xd *= zd
      
				xx = xd * @r_cos + zd * @r_sin + (@x_cam + 0.5) * 8
				yy = zd * @r_cos - xd * @r_sin + (@y_cam + 0.5) * 8
      
				x_pix = (xx * 2).to_i
				y_pix = (yy * 2).to_i
				x_tile = x_pix >> 4
				y_tile = y_pix >> 4
      
				block = level.get_block(x_tile, y_tile)
				col = block.floor_col
				tex = block.floor_tex
				unless floor
					col = block.ceil_col
					tex = block.ceil_tex
				end
      
				if tex < 0
					@z_buffer[x + y * @width] = -1
				else
					@z_buffer[x + y * @width] = zd
					@pixels[x + y * @width] = Art::FLOORS.pixels[((x_pix & 15) + (tex % 8) * 16) + ((y_pix & 15) + (tex / 8) * 16) * 128] * col
				end
        x += 1
			end
      y += 1
		end
  end
  
  def render_sprite(x, y, z, tex, color)
    xc = (x - @x_cam) * 2 - @r_sin * 0.2
    yc = (y - @z_cam) * 2
    zc = (z - @y_cam) * 2 - @r_cos * 0.2

    xx = xc * @r_cos - zc * @r_sin
    yy = yc
    zz = zc * @r_cos + xc * @r_sin

    return if zz < 0.1

    x_pixel = @x_center - (xx / zz * fov)
    y_pixel = yy / zz * fov + @y_center

    x_pixel0 = x_pixel - @height / zz
    x_pixel1 = x_pixel + @height / zz

    y_pixel0 = y_pixel - @height / zz
    y_pixel1 = y_pixel + @height / zz

    xp0 = x_pixel0.ceil
    xp1 = x_pixel1.ceil
    yp0 = y_pixel0.ceil
    yp1 = y_pixel1.ceil

    xp0 = 0 if xp0 < 0
    xp1 = @width if xp1 > @width
    yp0 = 0 if yp0 < 0
    yp1 = @height if yp1 > @height
    zz *= 4

    yp, max_yp = yp0, yp1 - 1
    while yp <= max_yp
    	ypr = (yp - y_pixel0) / (y_pixel1 - y_pixel0)
    	yt = (ypr * 16).to_i
      xp, max_xp = xp0, xp1 - 1
      while xp <= max_xp
    		xpr = (xp - x_pixel0) / (x_pixel1 - x_pixel0)
    		xt = (xpr * 16).to_i
    		if (@z_buffer[xp + yp * @width] > zz)
    			col = Art::SPRITES.pixels[(xt + tex % 8 * 16) + (yt + (tex / 8) * 16) * 128]
    			if col >= 0
    				@pixels[xp + yp * @width] = col * color
    				@z_buffer[xp + yp * @width] = zz
    			end
    		end
        xp += 1
    	end
      yp += 1
    end
  end
  
  def post_process(level)
    i, max = 0, width * height
    while i < max
			zl = @z_buffer[i]
			if zl < 0
				xx = ((i % width) - rot * 512 / (Math::PI * 2)).floor & 511
				yy = i / width
				@pixels[i] = Art::SKY.pixels[xx + yy * 512] * 0x444455
			else
				xp = i % @width
				yp = (i / @width) * 14
        
				xx = ((i % @width - @width / 2.0) / @width)
				col = @pixels[i]
				brightness = (300 - zl * 6 * (xx * xx * 2 + 1)).to_i
				brightness = brightness + ((xp + yp) & 3) * 4 >> 4 << 4
				brightness = 0 if brightness < 0
				brightness = 255 if brightness > 255

				r = (col >> 16) & 0xff
				g = (col >> 8) & 0xff
				b = (col) & 0xff

				r = r * brightness / 255
				g = g * brightness / 255
				b = b * brightness / 255

				@pixels[i] = r << 16 | g << 8 | b
			end
      i += 1
		end
  end
end