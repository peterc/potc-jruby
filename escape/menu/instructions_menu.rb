class InstructionsMenu < Menu
  def initialize
    super
    @tick_delay = 30
  end
  
  def render(target)
    target.fill(0, 0, 160, 120, 0)

		target.draw_string("Instructions", 40, 8, Art.get_col(0xffffff))
		
		lines = [
			"Use W,A,S,D to move, and",
			"the arrow keys to turn.",
			"",
			"The 1-8 keys select",
			"items from the inventory",
			"",
			"Space uses items",
		]
		
		lines.length.times do |i|
			target.draw_string(lines[i], 4, 32+i*8, Art.get_col(0xa0a0a0))
		end

		target.draw_string("-> Continue", 40, target.height - 16, Art.get_col(0xffff80)) if @tick_delay == 0
  end
  
  def tick(game, up, down, left, right, use)
    if @tick_delay > 0
      @tick_delay -= 1 
    elsif use
      Sound::CLICK1.play
      game.set_menu(TitleMenu.new)
    end
  end
end