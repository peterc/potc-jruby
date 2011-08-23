$: << File.expand_path(File.dirname(__FILE__))

ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + "/assets")

require 'java'
require 'jruby/synchronized'

require 'input_handler'
require 'component'
require 'game'

require 'gui/bitmap'
require 'gui/screen'
require 'gui/sprite'
require 'gui/rubble_sprite'

require 'menu/menu'
require 'menu/title_menu'
require 'menu/instructions_menu'
require 'menu/about_menu'

require 'art'
require 'sound'