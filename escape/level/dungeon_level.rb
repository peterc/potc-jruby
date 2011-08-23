class DungeonLevel < Level
	def initialize
	  super
		@wall_col = 0xC64954
		@floor_col = 0x8E4A51
		@ceil_col = 0x8E4A51
		@name = "The Dungeons"
	end

	def init(game, name, w, h, pixels)
	  super
		trigger(6, true)
		trigger(7, true)
	end

	def switch_level(id)
		@game.switch_level("start", 2) if id == 1
	end

	def get_loot(id)
		super
		@game.get_loot(Item::POWER_GLOVE) if (id == 1)
	end

	def trigger(id, pressed)
		super
		trigger(6, !pressed) if id == 5
		trigger(7, !pressed) if id == 4
	end
end