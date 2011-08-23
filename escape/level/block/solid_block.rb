class SolidBlock < Block
  def initialize
    super
    @solid_render = true
    @blocks_motion = true
  end
end