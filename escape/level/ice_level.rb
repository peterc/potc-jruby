class IceLevel < Level
  def initialize
    super
    @floor_col = 0xB8DBE0
    @ceil_col = 0xB8D8E0
    @wall_col = 0x6BE8FF
    @name = "The Frost Cave"
  end
  
  def switch_level(id)
    @game.switch_level("overworld", 5)    if id == 1
  end
  
  def get_loot(id)
    super
    @game.get_loot(Item::SKATES) if id == 1
  end
end