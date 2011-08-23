$: << File.expand_path(File.dirname(__FILE__))

ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + "/assets")

require 'java'
require 'input_handler'
require 'component'
require 'game'

require 'gui/bitmap'
require 'gui/screen'

require 'menu/menu'
require 'menu/title_menu'
require 'art'