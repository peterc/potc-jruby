class StartLevel < Level
  def initialize
    super
    @name = "The Prison"
  end
  
  #def decorate_block(x, y, block, col)
  #  super.decorate_block(x, y, block, col)
  #end
  
  #def get_block_by_color(x, y, col)
  #  super.get_block_by_color(x, y, col)
  #end
  
  def switch_level(id)
    @game.switch_evel("overworld", 1) if id == 1
    @game.switch_evel("dungeon", 1) if id == 2
  end
  
  def get_loot(id)
    super.get_loot id
  end
end