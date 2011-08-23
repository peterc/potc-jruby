class Level
	SOLID_WALL = SolidBlock.new
	WALL_COL = 0xB3CEE2
	FLOOR_COL = 0x9CA09B
	CEIL_COL = 0x9CA09B

  attr_accessor :x_spawn, :y_spawn, :blocks, :width, :height, :entities, :game, :name, :player

  def init(game, name, w, h, pixels)
	  @game = game
	  @player = game.player
	  @name = name              # beware: not in original
	  
	  @wall_tex = 0
	  @floor_tex = 0
	  @ceil_tex = 0
	  
	  SOLID_WALL.col = Art.get_col(WALL_COL)
	  SOLID_WALL.tex = Art.get_col(@wall_tex)
	  @width = w
	  @height = h
	  @blocks = Array.new(w * h) { Block.new }
	  @entities = []
	  
    h.times do |y|
      w.times do |x|
        col = pixels[x + y * w] & 0xffffff
        id = 255 - ((pixels[x + y * w] >> 24) & 0xff)
        block = get_block_by_color(x, y, col)
        block.id = id
        
        block.tex = @wall_text if block.tex == -1
				block.floor_tex = @floor_tex if block.floor_tex == -1
				block.ceil_tex = @ceil_tex if block.ceil_tex == -1
				block.col = Art.get_col(WALL_COL) if block.col == -1
				block.floor_col = Art.get_col(FLOOR_COL) if block.floor_col == -1
				block.ceil_col = Art.get_col(CEIL_COL) if block.ceil_col == -1
				
				blocks[x + y * w] = block
				block.level = self
				block.x = x
				block.y = y
      end
    end
    
    h.times do |y|
      w.times do |x|
        col = pixels[x + y * w] & 0xffffff
        decorate_block(x, y, @blocks[x + y * w], col)
      end
    end

	end

	def add_entity(e)
		entities << e
		e.level = self
		e.update_pos
	end

	def remove_entity_immediately(player)
		entities.delete player
		get_block(player.x_tileO, player.z_tileO).remove_entity player
	end

	def decorate_block(x, y, block, col)
		block.decorate self, x, y
		
		if col == 0xFFFF00
			@x_spawn = x
			@y_spawn = y
		end
		
		#add_entity BoulderEntity.new(x, y)   if col == 0xAA5500 
		#add_entity BatEntity.new(x, y)       if col == 0xff0000 
		#add_entity BatBossEntity.new(x, y)   if col == 0xff0001 
		#add_entity OgreEntity.new(x, y)      if col == 0xff0002 
		#add_entity BossOgre.new(x, y)        if col == 0xff0003 
		#add_entity EyeEntity.new(x, y)       if col == 0xff0004 
		#add_entity EyeBossEntit.newy(x, y)   if col == 0xff0005 
		#add_entity GhostEntity.new(x, y)     if col == 0xff0006 
		#add_entity GhostBossEntity.new(x, y) if col == 0xff0007 

		if col == 0x1A2108 || col == 0xff0007
			block.floor_tex = 7
			block.ceil_tex = 7
		end

		block.col = Art.get_col(0xa0a0a0) if col == 0xC6C6C6
		block.col = Art.get_col(0xa0a0a0) if col == 0xC6C697
		
		if col == 0x653A00
			block.floor_col = Art.get_col(0xB56600)
			block.floor_tex = 3 * 8 + 1
		end

		if col == 0x93FF9B
			block.col = Art.get_col(0x2AAF33)
			block.tex = 8
		end
	end

	def get_block_by_color(x, y, col)
	  # This could do with being made more Ruby-like! :-)
		return SolidBlock.new         if col == 0x93FF9B 
		#return PitBlock.new           if col == 0x009300
		return SolidBlock.new         if col == 0xFFFFFF 
		#return VanishBlock.new        if col == 0x00FFFF 
		return ChestBlock.new         if col == 0xFFFF64 
		#return WaterBlock.new         if col == 0x0000FF 
		#return TorchBlock.new         if col == 0xFF3A02 
		#return BarsBlock.new          if col == 0x4C4C4C 
		#return LadderBlock.new(false) if col == 0xFF66FF 
		#return LadderBlock.new(true)  if col == 0x9E009E 
		return LootBlock.new          if col == 0xC1C14D 
		#return DoorBlock.new          if col == 0xC6C6C6 
		#return SwitchBlock.new        if col == 0x00FFA7 
		#return PressurePlateBlock.new if col == 0x009380 
		#return IceBlock.new           if col == 0xff0005 
		#return IceBlock.new           if col == 0x3F3F60 
		#return LockedDoorBlock.new    if col == 0xC6C697 
		#return AltarBlock.new         if col == 0xFFBA02 
		#return SpiritWallBlock.new    if col == 0x749327 
		return Block.new              if col == 0x1A2108 
		#return FinalUnlockBlock.new   if col == 0x00C2A7 
		#return WinBlock.new           if col == 0x000056 
		Block.new
	end

	def get_block(x, y)
		return SOLID_WALL if x < 0 || y < 0 || x >= @width || y >= @height
		return @blocks[x + y * @width]
	end

	def self.clear
	  @loaded = {}
	end

	def self.load_level(game, name)
	  @loaded ||= {}
		return @loaded[name] if @loaded[name] 

    url = java.net.URL.new("file://" + ASSETS_DIR + '/level/' + name + '.png') # nasty little hack due to borked get_resource (means applet won't be easy..)
		img = ImageIO.read(url)
    
    w = img.width
    h = img.height
    
		pixels = []
		h.times do |y|
      w.times do |x|
        pixels[y * w + x] = img.getRGB(x, y)
      end
    end
    
		level = Level.by_name(name)
		level.init(game, name, w, h, pixels)
		@loaded[name] = level
    
		level
	end

	def self.by_name(name)
	  const_get((name.capitalize + "Level").to_sym).new
	end

	def contains_blocking_entity(x0, y0, x1, y1)
		xc = ((x1 + x0) / 2).floor
		zc = ((y1 + y0) / 2).floor
		rr = 2
		(zc - rr).upto(zc + rr - 1) do |z|
		  (xc - rr).upto(xc + rr - 1) do |x|
		    get_block(x, z).entities.each do |e|
		      return true if e.is_inside(x0, y0, x1, y1)
		    end
		  end
		end
		false
	end

  # TODOMUCHLATER: DRY this up! :-)
	def contains_blocking_non_flying_entity(x0, y0, x1, y1)
		xc = ((x1 + x0) / 2).floor
		zc = ((y1 + y0) / 2).floor
		rr = 2
		(zc - rr).upto(zc + rr - 1) do |z|
		  (xc - rr).upto(xc + rr - 1) do |x|
		    get_block(x, z).entities.each do |e|
		      return true if e.is_inside(x0, y0, x1, y1) && !e.flying
		    end
		  end
		end
		false
	end

	def tick
	  entities.each_with_index do |e, i|
	    e.tick if e.method(:tick).arity == 0    # FIXME: A hack because of some Java confusion..
			e.update_pos
			entities.delete(e) if e.is_removed   # beware: this might be wrong.. original removes element i--.. may not be necessary with Ruby's iterators
		end

    @height.times do |y|
      @width.times do |x|
				@blocks[x + y * width].tick
			end
		end
	end

	def trigger(id, pressed)
    @height.times do |y|
      @width.times do |x|
				b = @blocks[x + y * @width]
				b.trigger(pressed) if b.id == id
			end
		end
	end

	def switch_level(id); end

	def find_spawn(id)
    @height.times do |y|
      @width.times do |x|
				b = @blocks[x + y * @width]
				if b.id == id && b.is_a?(LadderBlock)
					@x_spawn = x
					@y_spawn = y
				end
			end
		end
	end

	def get_loot(id)
		game.get_loot(Item::PISTOL) if id == 20
		game.get_loot(Item::PISTOL) if id == 21
	end

	def win
		@game.win @player
	end

  def lose
		@game.lose @player
	end

	def show_loot_screen(item)
		@game.set_menu GotLootMenu.new(item)
	end
end