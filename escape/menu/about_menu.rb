class AboutMenu < Menu
  def initialize
    super
    @tick_delay = 30
  end
  
  def render(target)
    target.fill(0, 0, 160, 120, 0)

		target.draw_string("About", 60, 8, Art.get_col(0xffffff))
		
		lines = [
				"Prelude of the Chambered",
				"by Markus Persson.",
				"Made Aug 2011 for the",
				"21st Ludum Dare compo.",     # Fixed a typo here from the original
				"",
				"This game is freeware,",
				"and was made from scratch",
				"in just 48 hours.",
		]
		
		lines.length.times do |i|
			target.draw_string(lines[i], 4, 28+i*8, Art.get_col(0xa0a0a0))
		end

		target.draw_string("-> Continue", 40, target.height - 16, Art.get_col(0xffff80)) if @tick_delay == 0
  end
  
  def tick(game, up, down, left, right, use)
    if @tick_delay > 0
      @tick_delay -= 1 
    elsif use
      # Sound.click1.play
      game.set_menu(TitleMenu.new)
    end
  end
end