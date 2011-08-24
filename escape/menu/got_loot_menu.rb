class GotLootMenu < Menu
  attr_accessor :item
  
  def initialize(item)
    super()
    @item = item
    @tick_delay = 30
  end
  
  def render(target)
    str = "You found the #{@item.name}!"
    target.scale_draw(Art::ITEMS, 3, target.width / 2 - 8 * 3, 2, @item.icon * 16, 0, 16, 16, Art.get_col(@item.color))
    target.draw_string(str, (target.width - str.length * 6) / 2 + 2, 60 - 10, Art.get_col(0xffff80))
    
    str = @item.description
    target.draw_string(str, (target.width - str.length * 6) / 2 + 2, 60, Art.get_col(0xa0a0a0))
    
    target.draw_string("-> Continue", 40, target.height - 40, Art.get_col(0xffff80)) if @tick_delay == 0
  end
  
  def tick(game, up, down, left, right, use)
    if @tick_delay > 0
      @tick_delay -= 1 
    elsif use
      game.set_menu(nil)
    end
  end
end