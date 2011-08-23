java_import java.awt.event.KeyEvent

class Game
  attr_accessor :menu, :player, :time, :level, :pause_time
  
  def initialize
    @pause_time = 0
    @time = 0
    @player = nil
    @menu = TitleMenu.new
  end
  
  def new_game
    Level.clear
    @level = Level.load_level(self, "start")
    
    @player = Player.new
    @player.level = @level
    @level.player = @player
    @player.x = @level.x_spawn
    @player.z = @level.y_spawn
    @level.add_entity(@player)
    @player.rot = Math::PI + 0.4
  end
  
  def switch_level(name, id)
    @pause_time = 30
    @level.remove_entity_immediately(@player)
    @level = Level.load_level(self, name)
    @level.find_spawn(id)
    @player.x = @level.x_spawn
    @player.z = @level.y_spawn
    @level.get_block(@level.x_spawn, @level.y_spawn).wait = true
    @player.x += Math.sin(@player.rot) * 0.2
    @player.z += Math.cos(@player.rot) * 0.2
    @level.add_entity(@player)
  end
  
  def tick(keys)
		if @pause_time > 0
			@pause_time -= 1
			return
		end

		@time += 1

		strafe = keys[KeyEvent::VK_CONTROL] || keys[KeyEvent::VK_ALT] || keys[KeyEvent::VK_ALT_GRAPH] || keys[KeyEvent::VK_SHIFT]

		lk = keys[KeyEvent::VK_LEFT] || keys[KeyEvent::VK_NUMPAD4]
		rk = keys[KeyEvent::VK_RIGHT] || keys[KeyEvent::VK_NUMPAD6]

		up = keys[KeyEvent::VK_W] || keys[KeyEvent::VK_UP] || keys[KeyEvent::VK_NUMPAD8]
		down = keys[KeyEvent::VK_S] || keys[KeyEvent::VK_DOWN] || keys[KeyEvent::VK_NUMPAD2]
		left = keys[KeyEvent::VK_A] || (strafe && lk)
		right = keys[KeyEvent::VK_D] || (strafe && rk)

		turn_left = keys[KeyEvent::VK_Q] || (!strafe && lk)
		turn_right = keys[KeyEvent::VK_E] || (!strafe && rk)
    
		use = keys[KeyEvent::VK_SPACE]

		8.times do |i|
			next unless keys[KeyEvent::VK_1 + i]
			keys[KeyEvent::VK_1 + i] = false
			if @player
			  @player.selected_slot = i
			  @player.item_use_time = 0
			end
		end

		if keys[KeyEvent::VK_ESCAPE]
			keys[KeyEvent::VK_ESCAPE] = false
			set_menu PauseMenu.new unless menu
		end

		keys[KeyEvent::VK_SPACE] = false if use

		if menu
			keys[KeyEvent::VK_W] = keys[KeyEvent::VK_UP] = keys[KeyEvent::VK_NUMPAD8] = false
			keys[KeyEvent::VK_S] = keys[KeyEvent::VK_DOWN] = keys[KeyEvent::VK_NUMPAD2] = false
			keys[KeyEvent::VK_A] = false
			keys[KeyEvent::VK_D] = false

			menu.tick self, up, down, left, right, use
		else
			player.tick up, down, left, right, turn_left, turn_right
			player.activate if use

			level.tick
		end
	end
	
	def get_loot(item)
	  @player.add_loot(item)
	end
	
	def win(player)
	  set_menu(WinMenu.new(player))
	end
	
	def set_menu(menu)
	  @menu = menu
	end
	
	def lose(player)
	  set_menu(LoseMenu.new(player))
	end
end