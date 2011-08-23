java_import java.awt.event.KeyEvent

class Game
  attr_accessor :menu, :player, :time, :level
  
  def initialize
    @pause_time = 0
    @time = 0
    @player = nil
    @menu = TitleMenu.new
  end
  
  def tick(keys)
		if @pause_time > 0
			@pauseTime -= 1
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
			@player.selected_slot = i
			@player.item_use_time = 0
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
  
end