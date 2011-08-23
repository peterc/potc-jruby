class PauseMenu < Menu
  def initialize
    super
    @selected = 1
    @options = ["Abort game", "Continue"]
  end
  
  def render(target)
		target.draw_bitmap(Art::LOGO, 0, 8, 0, 0, 160, 36, Art.get_col(0xffffff))

		@options.each_with_index do |msg, i|
			col = 0x909090
			if @selected == i
				msg = "-> " + msg
				col = 0xffff80
			end
			target.draw_string(msg, 40, 60 + i * 10, Art.get_col(col))
		end

  end
  
  def tick(game, up, down, left, right, use)
    Sound::CLICK2.play if up || down
    selected -= 1 if up
    selected += 1 if down
    selected = 0 if selected < 0
    selected = @options.length - 1 if selected >= @options.length
    if use
      Sound::CLICK1.play
      if selected == 0
        game.set_menu TitleMenu.new
      elsif selected == 1
        game.set_menu nil
      end
    end
  end
end