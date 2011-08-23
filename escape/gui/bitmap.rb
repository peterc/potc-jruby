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
    bitmap.height.times do |y|
			y_pix = y + y_offs
			next if (y_pix < 0 || y_pix >= @height)

      bitmap.width.times do |x|
				x_pix = x + x_offs
				next if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[x + y * bitmap.width]
				@pixels[x_pix + y_pix * width] = src
			end
		end
	end
	
	def flip_draw(bitmap, x_offs, y_offs)
    bitmap.height.times do |y|
			y_pix = y + y_offs
			next if (y_pix < 0 || y_pix >= @height)

      bitmap.width.times do |x|
				x_pix = x_offs + bitmap.width - x - 1
				next if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[x + y * bitmap.width]
				@pixels[x_pix + y_pix * width] = src
			end
		end
	end
  
  def draw_bitmap(bitmap, x_offs, y_offs, xo, yo, w, h, col)
    h.times do |y|
			y_pix = y + y_offs
			next if (y_pix < 0 || y_pix >= @height)

      w.times do |x|
				x_pix = x + x_offs
				next if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[(x + xo) + (y + yo) * bitmap.width]

				if src >= 0
					@pixels[x_pix + y_pix * width] = src * col
				end
			end
		end
	end
	
	def scale_draw(bitmap, scale, x_offs, y_offs, xo, yo, w, h, col)
    (h * scale).times do |y|
			y_pix = y + y_offs
			next if (y_pix < 0 || y_pix >= @height)

      (w * scale).times do |x|
				x_pix = x + x_offs
				next if (x_pix < 0 || x_pix >= @width)

				src = bitmap.pixels[(x / scale + xo) + (y / scale + yo) * bitmap.width]

				if src >= 0
					@pixels[x_pix + y_pix * width] = src * col
				end
			end
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