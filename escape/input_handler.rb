java_import java.awt.event.KeyListener
java_import java.awt.event.FocusListener
java_import java.awt.event.MouseListener
java_import java.awt.event.MouseMotionListener

class InputHandler
  include KeyListener
  include FocusListener
  include MouseListener
  include MouseMotionListener
  
  attr_accessor :keys
  
  def initialize
    super
    @keys = Array.new(65536, false)
  end
  
  def mouse_dragged(arg); end
  def mouse_moved(arg); end
  def mouse_clicked(arg); end
  def mouse_entered(arg); end
  def mouse_exited(arg); end
  def mouse_pressed(arg); end
  def mouse_released(arg); end
  def focus_gained(arg); end
  
  def focus_lost(arg)
    keys.each_with_index { |k, i| @keys[i] = true }
  end
  
  def key_pressed(e)
    code = e.key_code
		@keys[code] = true if code > 0 && code < keys.length
  end
  
  def key_released(e)
    code = e.key_code 
		@keys[code] = false if code > 0 && code < keys.length
  end
  
  def key_typed(arg); end
end