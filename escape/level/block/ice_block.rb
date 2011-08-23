class IceBlock < Block
  def initialize
    super
    @blocks_motion = false
    @floor_tex = 16
  end
  
  def tick
    super
    @floor_col = Art.get_col(0x8080ff)
  end
  
  def get_walk_speed(player)
    player.get_selected_item == Item::SKATES ? 0.05 : 1.4
  end
  
  def get_friction(player)
    player.get_selected_item == Item::SKATES ? 0.98 : 1
  end
  
  def blocks(entity)
    return false if entity.is_a?(Player)
    return false if entity.is_a?(Bullet)
    return false if entity.is_a?(EyeBossEntity)
    return false if entity.is_a?(EyeEntity)
    true
  end  
end