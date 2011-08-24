class Screen < Bitmap
  PANEL_HEIGHT = 29
  
  def initialize(width, height)
    super(width, height)
    @viewport = Bitmap3D.new(width, height - PANEL_HEIGHT)    
  end
  
  def render(game, has_focus)
    if game.level
      item_used = game.player.item_use_time > 0
      item = game.player.items[game.player.selected_slot]
      
      if game.pause_time > 0
        render_entering(game)
      else
        @viewport.render game
        @viewport.post_process game.level
        
        block = game.level.get_block((game.player.x + 0.5).to_i, (game.player.z + 0.5).to_i)
        if block.messages && has_focus
          render_messages(block)
        end
        
        draw @viewport, 0, 0
        xx = (game.player.turn_bob * 32).to_i
        yy = (Math.sin(game.player.bob_phase * 0.4) * 1 * game.player.bob + game.player.bob * 2).to_i
        
        xx = yy = 0 if item_used
        xx += @width / 2
        yy += @height - PANEL_HEIGHT - 15 * 3
        if item != Item::NONE
          scale_draw(Art::ITEMS, 3, xx, yy, 16 * item.icon + 1, 16 + 1 + (item_used ? 16 : 0), 15, 15, Art.get_col(item.color))
        end
        
        if game.player.hurt_time > 0 || game.player.dead
          offs = 1.5 - game.player.hurt_time / 30.0
          rnd = rand(111)
          offs = 0.5 if game.player.dead
          i, max_i = 0, @pixels.length
          while i < max_i
            xp = ((i % @width) - @viewport.width / 2.0) / @width * 2
            yp = ((i / @width) - @viewport.height / 2.0) / @viewport.height * 2
            @pixels[i] = (rand(5) / 4) * 0x550000 if (rand + offs < Math.sqrt(xp * xp + yp * yp))
            i += 1
          end
        end  
      end
      
      draw_bitmap(Art::PANEL, 0, @height - PANEL_HEIGHT, 0, 0, @width, PANEL_HEIGHT, Art.get_col(0x707070))
      
      draw_string("å", 3, @height - 26 + 0, 0x00ffff)
			draw_string(game.player.keys.to_s + "/4", 10, @height - 26 + 0, 0xffffff)
			draw_string("Ä", 3, @height - 26 + 8, 0xffff00)
			draw_string(game.player.loot.to_s, 10, @height - 26 + 8, 0xffffff)
			draw_string("Å", 3, @height - 26 + 16, 0xff0000)
			draw_string(game.player.health.to_s, 10, @height - 26 + 16, 0xffffff)

      render_slots(game)

			draw_bitmap(Art::ITEMS, 30 + game.player.selected_slot * 16, @height - PANEL_HEIGHT + 2, 0, 48, 17, 17, Art.get_col(0xffffff));

			draw_string(item.name, 26 + (8 * 16 - item.name.length() * 4) / 2, @height - 9, 0xffffff);
    else
      fill 0, 0, @width, @height, 0
    end

    if game.menu
      render_menu(game)
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
  
  def render_entering(game)
    fill 0, 0, @width, @height, 0
    messages = "Entering " + game.level.name
    messages.each_with_index do |msg, y|
      draw_string(msg, (@width - msg.length * 6) / 2, (@viewport.height - messages.length * 8) / 2 + y * 8 + 1, 0x111111)
      draw_string(msg, (@width - msg.length * 6) / 2, (@viewport.height - messages.length * 8) / 2 + y * 8, 0x555544)
    end
  end
  
  def render_messages(block)
    block.messages.each_with_index do |msg, y|
      draw_string(msg, (@width - msg.length * 6) / 2, (@viewport.height - block.messages.length * 8) / 2 + y * 8 + 1, 0x111111)
      draw_string(msg, (@width - msg.length * 6) / 2, (@viewport.height - block.messages.length * 8) / 2 + y * 8, 0x555544)
    end
  end
  
  def render_slots(game)
  	8.times do |i|
			slot_item = game.player.items[i]
			if slot_item != Item::NONE
				draw_bitmap(Art::ITEMS, 30 + i * 16, @height - PANEL_HEIGHT + 2, slot_item.icon * 16, 0, 16, 16, Art.get_col(slot_item.color))
				
				if slot_item == Item::PISTOL
					str = game.player.ammo.to_s
					draw_string(str, 30 + i * 16 + 17 - str.length() * 6, @height - PANEL_HEIGHT + 1 + 10, 0x555555)
				end
				
				if slot_item == Item::POTION
					str = game.player.potions.to_s
					draw_string(str, 30 + i * 16 + 17 - str.length() * 6, @height - PANEL_HEIGHT + 1 + 10, 0x555555)
				end
			end
		end
  end
  
  def render_menu(game)
    @pixels.length.times do |i|
      @pixels[i] = (@pixels[i] & 0xfcfcfc) >> 2
    end
    game.menu.render self
  end
end