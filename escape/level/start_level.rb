class StartLevel < Level
  def initialize
    super
    @name = "The Prison"
  end
  
  def switch_level(id)
    @game.switch_level("overworld", 1) if id == 1
    @game.switch_level("dungeon", 1) if id == 2
  end  
end