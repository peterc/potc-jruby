class Sound
  attr_accessor :clip
  
  def self.load_sound(file_name)
    sound = new
    
    url = java.net.URL.new("file://" + ASSETS_DIR + file_name) # nasty little hack due to borked get_resource (means applet won't be easy..)
    ais = AudioSystem.get_audio_input_stream(url)
    clip = AudioSystem.clip
    clip.open(ais)
    sound.clip = clip
    
    sound
  end
  
  def play
    if clip
      # TODO
    end
  end
end