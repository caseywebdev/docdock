require "sinatra"

get "/test/:zing" do
	@blah = "BLAH"
	@sum = 5
	erb :test
end

get "/sum/*" do
	params[:splat][0].split("/").map{ |s| s.to_i }.inject(:+).to_s
	"test
	test
	test"
end