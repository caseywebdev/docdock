#convert any base, from base 10 integer to base x string
module AnyBaseIToS
	def b(base)
		i = self
		val = ""
		len = base.length
		pow = 0
		#do math, match up the modulo with the proper base x string index, etc...
		begin
			mod = i%len**(pow+1)
			val += base[mod/len**pow]
			i -= mod
			pow += 1
		end while i > 0
		val.reverse
	end
end

#convert any base, from base x string to base 10 integer
module AnyBaseSToI
	def b(base)
		val = 0
		len = base.length
		#123 = 1*baseLength**2 + 2*baseLength**1 + 3*baseLength**0, simple pattern
		self.split("").reverse.each_with_index { |c, i| val += base.index(c)*len**i }
		val
	end
end

#extend our base classes with our new module
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