module AnyBaseIToS
	def b(base)
		i = self
		val = ""
		len = base.length
		pow = 0
		begin
			mod = i%len**(pow+1)
			val += base[mod/len**pow]
			i -= mod
			pow += 1
		end while i > 0
		val.reverse
	end
end

module AnyBaseSToI
	def b(base)
		val = 0
		len = base.length
		self.split("").reverse.each_with_index { |c, i| val += base.index(c)*len**i }
		val
	end
end

class Float
	include AnyBaseIToS
end

class Fixnum
	include AnyBaseIToS
end

class Bignum
	include AnyBaseIToS
end

class String
	include AnyBaseSToI
end