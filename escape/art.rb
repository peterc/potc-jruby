java_import java.awt.image.BufferedImage
java_import javax.imageio.ImageIO

class Art < java.lang.Object
  def self.load_bitmap(file_name)
    url = java.net.URL.new("file://" + ASSETS_DIR + file_name) # nasty little hack due to borked get_resource (means applet won't be easy..)
    img = ImageIO.read(url)
            
    w = img.width
    h = img.height
    
    result = Bitmap.new(w, h)
    #result.pixels = img.getRGB(0, 0, w, h, nil, 0, w)
    
    h.times do |y|
      w.times do |x|
        #puts img.getRGB(x, y) + (2 ** 32)
        result.pixels[y * w + x] = img.getRGB(x, y)
      end
    end
    
    result.pixels.length.times do |i|
      inp = result.pixels[i] + (2 ** 32)
    
      col = (inp.to_i & 0xf) >> 2
      col = -1 if inp == 0xffff00ff
      result.pixels[i] = col
    end
    
    result    
  end
  
  def self.get_col(c)
		r = (c >> 16) & 0xff
		g = (c >> 8) & 0xff
		b = (c) & 0xff

		r = r * 0x55 / 0xff
		g = g * 0x55 / 0xff
		b = b * 0x55 / 0xff

		(r << 16 | g << 8 | b)
	end
  
  FONT = load_bitmap("/tex/font.png")
  LOGO = load_bitmap("/gui/logo.png")
end