class SolidBlock < Block
  def initialize
    super
    @solid_render = true
    @blocks_motion = true
    @tex = 0
  end
end