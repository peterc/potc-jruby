$: << File.expand_path(File.dirname(__FILE__))

ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + "/assets")

require 'java'
require 'jruby/synchronized'

require 'input_handler'
require 'component'
require 'game'

require 'entities/item'

require 'level/block/block'
require 'level/block/solid_block'
require 'level/block/loot_block'
require 'level/block/chest_block'
require 'level/block/water_block'
require 'level/block/ice_block'

require 'level/level'
require 'level/start_level'

require 'gui/bitmap'
require 'gui/screen'
require 'gui/sprite'
require 'gui/rubble_sprite'

require 'menu/menu'
require 'menu/title_menu'
require 'menu/instructions_menu'
require 'menu/about_menu'
require 'menu/pause_menu'

require 'entities/entity'
require 'entities/player'

require 'art'
require 'sound'