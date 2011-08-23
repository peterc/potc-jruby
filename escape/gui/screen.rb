class Screen < Bitmap
  PANEL_HEIGHT = 29
  
  def initialize(width, height)
    super(width, height)
    #@viewport = Bitmap3D.new(width, height - PANEL_HEIGHT)    
  end
  
  def render(game, has_focus)
    if game.level
      item_used = game.player.item_use_time > 0
      item = game.player.items[game.player.selected_slot]
      
      if game.pause_time > 0
        fill 0, 0, @width, @height, 0
        messages = "Entering " + game.level.name
        messages.each do |msg|
          draw_string(msg, (@width - msg.length * 6) / 2, (@viewport.height - messages.length * 8) / 2 + y * 8 + 1, 0x111111)
          draw_string(msg, (@width - msg.length * 6) / 2, (@viewport.height - messages.length * 8) / 2 + y * 8, 0x555544)
        end
      else
        #viewport.render
        
        # TODO!!!
        
        
      end
      
      draw_bitmap(Art::PANEL, 0, @height - PANEL_HEIGHT, 0, 0, @width, PANEL_HEIGHT, Art.get_col(0x707070))
      
      draw_string("å", 3, @height - 26 + 0, 0x00ffff)
			draw_string(game.player.keys.to_s + "/4", 10, @height - 26 + 0, 0xffffff)
			draw_string("Ä", 3, @height - 26 + 8, 0xffff00)
			draw_string(game.player.loot.to_s, 10, @height - 26 + 8, 0xffffff)
			draw_string("Å", 3, @height - 26 + 16, 0xff0000)
			draw_string(game.player.health.to_s, 10, @height - 26 + 16, 0xffffff)

			8.times do |i|
				slot_item = game.player.items[i]
				if slot_item != Item::NONE
					draw_bitmap(Art::ITEMS, 30 + i * 16, @height - PANEL_HEIGHT + 2, slot_item.icon * 16, 0, 16, 16, Art.get_col(slot_item.color))
					
					if slot_item == Item::PISTOL
						str = "" + game.player.ammo
						draw_string(str, 30 + i * 16 + 17 - str.length() * 6, @height - PANEL_HEIGHT + 1 + 10, 0x555555)
					end
					
					if slot_item == Item::POTION
						str = "" + game.player.potions
						draw_string(str, 30 + i * 16 + 17 - str.length() * 6, @height - PANEL_HEIGHT + 1 + 10, 0x555555)
					end
				end
			end

			draw_bitmap(Art::ITEMS, 30 + game.player.selected_slot * 16, @height - PANEL_HEIGHT + 2, 0, 48, 17, 17, Art.get_col(0xffffff));

			draw_string(item.name, 26 + (8 * 16 - item.name.length() * 4) / 2, @height - 9, 0xffffff);
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