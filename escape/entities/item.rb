class Item
	NONE =        new(-1, 0xFFC363, "",               "")
	POWER_GLOVE = new( 0, 0xFFC363, "Power Glove", 		"Smaaaash!!")
	PISTOL =      new( 1, 0xEAEAEA, "Pistol",         "Pew, pew, pew!")
	FLIPPERS =    new( 2, 0x7CBBFF, "Flippers", 			"Splish splash!")
	CUTTERS =     new( 3, 0xCCCCCC, "Cutters", 			  "Snip, snip!")
	SKATES =      new( 4, 0xAE70FF, "Skates", 				"Sharp!")
	KEY =         new( 5, 0xFF4040, "Key", 					  "How did you get this?")
	POTION =      new( 6, 0x4AFF47, "Potion", 				"Healthy!")
	
	attr_accessor :icon, :color, :name, :description
	
	def initialize(icon, color, name, description)
		@icon = icon
		@color = color
		@name = name
		@description = description
	end
end