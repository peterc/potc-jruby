class TitleMenu < Menu
  
  def initialize
    super
    @first_tick = true
    @selected = 0
    @options = ["New game", "Instructions", "About"]
  end
    
	def render(target)
		target.fill(0, 0, 160, 120, 0)
		target.draw_bitmap(Art::LOGO, 0, 8, 0, 0, 160, 36, Art.get_col(0xffffff))

		@options.each_with_index do |msg, i|
			col = 0x909090
			if @selected == i
				msg = "-> " + msg
				col = 0xffff80
			end
			target.draw_string(msg, 40, 60 + i * 10, Art.get_col(col))
		end

		target.draw_string("Copyright (C) 2011 Mojang", 1+4, 120 - 9, Art.get_col(0x303030))
	end

	def tick(game, up, down, left, right, use)
		if @first_tick
			@first_tick = false
			Sound::ALTAR.play()
		end
		
		Sound::CLICK2.play if up || down
		@selected -= 1 if up
		@selected += 1 if down

		@selected = 0 if @selected < 0
		@selected = @options.length - 1 if @selected >= @options.length
		
		if use
			Sound::CLICK1.play
			if @selected == 0
				game.menu = nil
				game.new_game
			end
			if @selected == 1
				game.set_menu(InstructionsMenu.new)
			end
			if @selected == 2
				game.set_menu(AboutMenu.new)
			end
		end
	end
    
end