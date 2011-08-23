java_import javax.sound.sampled.AudioSystem

class Sound
  attr_accessor :clip
  
  def self.load_sound(file_name)
    sound = new
    
    url = java.net.URL.new("file://" + ASSETS_DIR + file_name) # nasty little hack due to borked get_resource (means applet won't be easy..)
    ais = AudioSystem.get_audio_input_stream(url)
    clip = AudioSystem.clip
    clip.open(ais)
    clip.extend JRuby::Synchronized
    sound.clip = clip
    
    sound
  end
  
  def play
    if clip
      Thread.new do
        clip.stop
        clip.frame_position = 0
        clip.start
      end
    end
  end
  
  %w{altar bosskill click1 click2 hit hurt hurt2 kill death splash key pickup roll shoot treasure crumble slide cut thud ladder potion}.each do |name|
    const_set name.upcase, load_sound("/snd/#{name}.wav")
  end
end