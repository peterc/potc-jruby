class Bitmap
  attr_accessor :pixels
  attr_reader :height, :width
  
  CHARS = "" +
			"ABCDEFGHIJKLMNOPQRSTUVWXYZ.,!?\"'/\\<>()[]{}" +
			"abcdefghijklmnopqrstuvwxyz_               " +
			"0123456789+-=*:;ÖÅÄå                      " +
			"";
  
  def initialize(width, height)
    @width = width
    @height = height
    @pixels = Array.new(width * height, 0)
  end
  
  def draw(bitmap, x_offs, y_offs)
    y, max_y = 0, bitmap.height
    while y < max_y
			y_pix = y + y_offs
			next(y += 1) if (y_pix < 0 || y_pix >= @height)

      x, max_x = 0, bitmap.width
      while x < max_x
				x_pix = x + x_offs
				next(x += 1) if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[x + y * bitmap.width]
				@pixels[x_pix + y_pix * width] = src
        x += 1
			end
      y += 1
		end
	end
	
	def flip_draw(bitmap, x_offs, y_offs)
    y, max_y = 0, bitmap.height
    while y < max_y
			y_pix = y + y_offs
			next(y += 1) if (y_pix < 0 || y_pix >= @height)

      x, max_x = 0, bitmap.width
      while x < max_x
				x_pix = x_offs + bitmap.width - x - 1
				next(x += 1) if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[x + y * bitmap.width]
				@pixels[x_pix + y_pix * width] = src
        x += 1
			end
      y += 1
		end
	end
  
  def draw_bitmap(bitmap, x_offs, y_offs, xo, yo, w, h, col)
    y, max_y = 0, h
    while y < max_y
			y_pix = y + y_offs
			next(y += 1) if (y_pix < 0 || y_pix >= @height)

      x, max_x = 0, w
      while x < max_x
				x_pix = x + x_offs
				next(x += 1) if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[(x + xo) + (y + yo) * bitmap.width]

				if src >= 0
					@pixels[x_pix + y_pix * width] = src * col
				end
        x += 1
			end
      y += 1
		end
	end
	
	def scale_draw(bitmap, scale, x_offs, y_offs, xo, yo, w, h, col)
    y, max_y = 0, (h * scale)
    while y < max_y
			y_pix = y + y_offs
			next(y += 1) if (y_pix < 0 || y_pix >= @height)

      x, max_x = 0, (w * scale)
      while x < max_x
				x_pix = x + x_offs
				next(x += 1) if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[(x / scale + xo) + (y / scale + yo) * bitmap.width]

				if src >= 0
					@pixels[x_pix + y_pix * width] = src * col
				end
        x += 1
			end
      y += 1
		end
	end
	
	def draw_string(string, x, y, col)
    string.chars.each_with_index do |char, i|
      ch = CHARS.index(char)
			next if ch < 0

			xx = ch % 42
			yy = ch / 42
			draw_bitmap(Art::FONT, x + i * 6, y, xx * 6, yy * 8, 5, 8, col)
		end
  end
	
	def fill(x0, y0, x1, y1, color)
    y0.upto(y1 - 1) do |y|
      x0.upto(x1 - 1) do |x|
        @pixels[x + y * @width] = color
      end
    end
  end
end