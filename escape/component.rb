java_import java.awt.Canvas
java_import java.awt.BorderLayout
java_import java.awt.Dimension
java_import javax.swing.JFrame
java_import javax.swing.JPanel
java_import java.awt.Toolkit
java_import java.awt.image.BufferedImage
java_import java.awt.image.BufferStrategy
java_import java.awt.Point
java_import java.lang.System

class Component < Canvas
  include java.lang.Runnable
  
  SERIAL_VERSION_UID = 1
  WIDTH = 160
  HEIGHT = 120
  SCALE = 4
  SCALED_WIDTH = WIDTH * SCALE
  SCALED_HEIGHT = HEIGHT * SCALE
  
  attr_accessor :running
  
  def initialize
    super
    
    size = Dimension.new(SCALED_WIDTH, SCALED_HEIGHT)
    self.minimum_size = self.maximum_size = self.preferred_size = self.size = size

    @game = Game.new
    @screen = Screen.new(WIDTH, HEIGHT)
    @img = BufferedImage.new(WIDTH, HEIGHT, BufferedImage::TYPE_INT_RGB)
    @pixels = @img.raster.data_buffer.data
    @input_handler = InputHandler.new
    add_key_listener @input_handler
    add_focus_listener @input_handler
    add_mouse_listener @input_handler
    add_mouse_motion_listener @input_handler
    @empty_cursor = Toolkit.default_toolkit.create_custom_cursor(BufferedImage.new(16, 16, BufferedImage::TYPE_INT_ARGB), Point.new(0, 0), "empty")
    @default_cursor = cursor
    @running = false
    @had_focus = false
  end
  
  def start
    return if @running
    @running = true
    @thread = java.lang.Thread.new(self)
    @thread.start
  end
  
  def stop
    return unless @running
    @running = false
    begin
      @thread.join
    rescue => e
      p e
    end
  end
  
  def run
    frames = 0
    unprocessed_seconds = 0
    last_time = System.nano_time
    seconds_per_tick = 1 / 60.0
    tick_count = 0
    
    request_focus
    
    while running
      now = System.nano_time
      passed_time = now - last_time
      last_time = now
      passed_time = 0 if passed_time < 0
      passed_time = 100000000 if passed_time > 100000000
      
      unprocessed_seconds += passed_time / 1000000000.0
      ticked = false
      
      while unprocessed_seconds > seconds_per_tick    
        tick
        unprocessed_seconds -= seconds_per_tick
        ticked = true
        
        tick_count += 1
        if tick_count % 60 == 0
          System.out.println frames.to_s + " fps"
          #last_time += 1000
          frames = 0
        end
      end
        
      if ticked
        render
        frames += 1
      else
        begin
          java.lang.Thread.sleep 1
        rescue => e
          p e
        end
      end
    end
  end
  
  # A place for experiments - this will run ticks and renders together flat out at max 60 fps
  def naive_run
    frames = 0
    last_time = Time.now.to_f
    ticks = 0
    request_focus
    
    while running
      now = Time.now.to_f
      passed_time = now - last_time
      
      if passed_time >= 0.0167
        tick
        render
        ticks += 1
        last_time = now
      end
    end
  end
  
  def tick
    @game.tick(@input_handler.keys)
  end
  
  def render
    if @had_focus != has_focus
      has_focus = !@had_focus
      set_cursor @had_focus ? @empty_cursor : @default_cursor
    end
    
    bs = get_buffer_strategy
    unless bs
      create_buffer_strategy 2
      return
    end
    
    @screen.render(@game, has_focus)
    
    i, max_i = 0, WIDTH * HEIGHT - 1
    while i <= max_i
      @pixels[i] = @screen.pixels[i]
      i += 1
    end
    # Not having much luck here but leaving for now..
    #@img.raster.set_pixels(0, 0, WIDTH, HEIGHT, @screen.pixels)
    #@img.raster.set_data_elements(0, 0, WIDTH, HEIGHT, @screen.pixels)
    
    g = bs.draw_graphics
    g.fill_rect 0, 0, WIDTH, HEIGHT
    g.draw_image @img, 0, 0, SCALED_WIDTH, SCALED_HEIGHT, nil
    g.dispose
    bs.show
  end

  def self.main
    game = new 
    frame = JFrame.new("Prelude of the Chambered!")
    panel = JPanel.new(BorderLayout.new)
    panel.add(game, BorderLayout::CENTER)
    frame.content_pane = panel
    frame.pack
    frame.resizable = false
    frame.location_relative_to = nil
    frame.default_close_operation = JFrame::EXIT_ON_CLOSE
    frame.visible = true
    game.start
  end
end

