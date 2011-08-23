class BoulderEntity < Entity
  COLOR = Art.get_col(0xAFA293)

	def initialize(x, z)
	  super()
	  @x = x
	  @z = z	  
		@sprite = Sprite.new(0, 0, 0, 16, COLOR)
		@sprites << @sprite
		@roll_dist = 0
	end

	def tick
		@roll_dist += Math.sqrt(@xa * @xa + @za * @za);
		@sprite.tex = 8 + ((@roll_dist * 4).to_i & 1)
		xao = @xa
		zao = @za
		move
		@xa = -xao * 0.3 if @xa == 0 && xao != 0
		@za = -zao * 0.3 if @za == 0 && zao != 0
		@xa *= 0.98
		@za *= 0.98
		@xa = @za = 0 if (@xa * @xa + @za * @za < 0.0001)
	end

	def use(source, item)
		return false if item != Item::POWER_GLOVE
		Sound::ROLL.play

		@xa += Math.sin(source.rot) * 0.1
		@za += Math.cos(source.rot) * 0.1
		true
	end
end
