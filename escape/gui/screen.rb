class Screen < Bitmap
  PANEL_HEIGHT = 29
  
  def initialize(width, height)
    super(width, height)
    #@viewport = Bitmap3D.new(width, height - PANEL_HEIGHT)    
  end
  
  def render(game, has_focus)
    if game.level
      # TODO      
    else
      fill 0, 0, @width, @height, 0
    end

    if game.menu
      @pixels.length.times do |i|
        @pixels[i] = (@pixels[i] & 0xfcfcfc) >> 2
      end
      game.menu.render self
    end
    
    unless has_focus
      @pixels.length.times do |i|
        @pixels[i] = (@pixels[i] & 0xfcfcfc) >> 2        
      end
      
      if java.lang.System.current_time_millis / 450 % 2 != 0
        msg = "Click to focus!"
        draw_string msg, (@width - msg.length() * 6) / 2, @height / 3 + 4, 0xffffff
      end
    end
    
    
    #0.upto(@width * @height - 1) do |i|      
    #  @pixels[i] = rand(2).zero? ? 0x00ff0000 : 0x0000ff00
    #end
  end
end