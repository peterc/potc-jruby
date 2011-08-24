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
require 'level/block/door_block'
require 'level/block/locked_door_block'
require 'level/block/vanish_block'
require 'level/block/torch_block'
require 'level/block/bars_block'
require 'level/block/ladder_block'
require 'level/block/pressure_plate_block'
require 'level/block/pit_block'

require 'level/level'
require 'level/start_level'
require 'level/overworld_level'
require 'level/dungeon_level'
require 'level/ice_level'

require 'gui/bitmap'
require 'gui/bitmap3d'
require 'gui/screen'
require 'gui/sprite'
require 'gui/rubble_sprite'
require 'gui/poof_sprite'

require 'menu/menu'
require 'menu/title_menu'
require 'menu/instructions_menu'
require 'menu/about_menu'
require 'menu/pause_menu'
require 'menu/got_loot_menu'

require 'art'
require 'sound'

require 'entities/entity'
require 'entities/player'
require 'entities/bullet'
require 'entities/enemy_entity'
require 'entities/bat_entity'
require 'entities/boulder_entity'

