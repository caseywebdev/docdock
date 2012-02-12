require "sinatra"

configure do
	#set the base string we'll use for converting from base 10
	BASE_62 = ("0".."9").to_a.join("")+("a".."z").to_a.join("")+("A".."Z").to_a.join("")
end

class Fixnum
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

class String
	def b(base)
		val = 0
		len = base.length
		self.split("").reverse.each_with_index { |c, i| val += base.index(c)*len**i }
		val
	end
end

get "/" do
	@title = false
	@echo = `ls`
	erb :index
end

__END__
@@index
<!doctype html>

<html>

	<head>
		<title><%= @title ? "#{@title} | docdock" : "docdock | The Dock for Docs" %></title>
	</head>
	
	<body>
		<%= "1rQ5".b BASE_62 %>
	</body>
	
</html>