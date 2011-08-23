class Bullet < Entity
  attr_accessor :owner

	def initialize(owner, x, z, rot, pow, sprite, col)
	  super()
	  
		@r = 0.01;
		@owner = owner

		@xa = Math.sin(rot) * 0.2 * pow
		@za = Math.cos(rot) * 0.2 * pow
		@x = x - za / 2
		@z = z + xa / 2

		@sprites << Sprite.new(0, 0, 0, 8 * 3 + sprite, Art.get_col(col))

		@flying = true
	end

	def tick
		xao = @xa
		zao = @za
		move

		remove if (@xa == 0 && @za == 0) || @xa != xao || @za != zao
  end

	def blocks(entity, x2, z2, r2)
		return false if entity.is_a?(Bullet)
		return false if entity == @owner
		super
	end

	def collide(entity); end
end