class OverworldLevel < Level
  def initialize
    super
    @ceil_tex = -1
    @floor_col = 0x508253
    @floor_tex = 8 * 3
    @wall_col = 0xa0a0a0
    @name = "The Island"
  end
  
  def switch_level(id)
    @game.switch_level("start", 1)    if id == 1
    @game.switch_level("crypt", 1)    if id == 2
    @game.switch_level("temple", 1)   if id == 3
    @game.switch_level("ice", 1)      if id == 5
  end
  
  def get_loot(id)
    super
    @game.get_loot(Item::CUTTERS) if id == 1
  end
end