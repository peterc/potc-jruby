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
    
    # Think it's a bad idea to bother detecting focus on a desktop-only version (for now) 
    #
    #unless has_focus
    #  @pixels.length.times do |i|
    #    @pixels[i] = (@pixels[i] & 0xfcfcfc) >> 2        
    #  end
    #  
    #  if java.lang.System.current_time_millis / 450 % 2 != 0
    #    msg = "Click to focus!"
    #    draw_string msg, (@width - msg.length() * 6) / 2, @height / 3 + 4, 0xffffff
    #  end
    #end
  end
end