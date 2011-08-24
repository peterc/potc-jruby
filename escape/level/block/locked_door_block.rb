class LockedDoorBlock < DoorBlock
  def initialize
    super
    @tex = 5
  end
  
  def use(level, item)
    false
  end
  
  def trigger(pressed)
    @open = pressed
  end
end