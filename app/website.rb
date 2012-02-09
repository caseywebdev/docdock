require "sinatra"

configure do
	BASE_62 = ("0".."9").to_a.join("")+("a".."z").to_a.join("")+("A".."Z").to_a.join("")
end

def sToI(s, base)
	val = 0
	len = base.length
	s.split("").reverse.each_with_index { |c, i| val += base.index(c)*len**i }
	val
end

def iToS(i, base)
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

get "/" do
	@title = false
	@echo = `ls`
	erb :index
end