$: << File.expand_path(File.dirname(__FILE__))

ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + "/assets")

require 'java'
require 'input_handler'
require 'component'
require 'game'
require 'sound'

require 'gui/bitmap'
require 'gui/screen'
require 'gui/sprite'
require 'gui/rubble_sprite'

require 'menu/menu'
require 'menu/title_menu'
require 'art'