#we get what we need
require "sinatra"
require "redis"
require "json"
require_relative "anyBase"

#grab the first line from a doc to use as the title
def getTitle(doc)
	firstLine = doc.strip[/^[^\n]+(?=\n|$)/]
	firstLine.length <= TITLE_LENGTH ? firstLine : firstLine[0,TITLE_LENGTH-3]+"..."
end

#pull the RECENT_DOCS recent docs from the Redis
def getRecentDocs
	lastId = REDIS.zcard "docs"
	recentDocs = []
	REDIS.zrangebyscore("docs", lastId-RECENT_DOCS+1, lastId).reverse.each_with_index do |doc, i|
		recentDocs << {
			id: (lastId-i).b(BASE_62),
			doc: getTitle(doc)
		}
	end
	recentDocs
end

#define constants, connect to Redis, etc...
configure do
	#set the base string we'll use for converting from base 10
	BASE_62 = ("0".."9").to_a.join("")+("a".."z").to_a.join("")+("A".."Z").to_a.join("")
	#define our Redis instance (params from Heroku getting started)
	#private redistogo.com url shouldn't be public, but I trust everyone on the internet so it's okay
	uri = URI.parse("redis://SituatedBanana:fcfa73afd9670528dde35516b026f4dd@carp.redistogo.com:9422/")
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	REDIS.select 0
	#set the default page title, that is, if @title is never set
	DEFAULT_TITLE = "docdock | The Dock for Docs"
	#set the title appendage so that the final title looks like @title+TITLE_APPENDAGE
	TITLE_APPENDAGE = " | docdock"
	#max characters of doc to show as the title
	TITLE_LENGTH = 64
	#number of recent docs to show
	RECENT_DOCS = 90
	set :public_folder, "#{File.dirname __FILE__}/../public"
end

#root request
get "/" do
	@recentDocs = getRecentDocs()
	erb :index
end

#compile CoffeeScript and SCSS if it was changed
get /^\/(coffee|scss)\/(.*)$/ do |type, file|
	ext = type == "coffee" ? "js" : "css"
	path = "#{File.dirname __FILE__}/../#{type}/#{file}.#{type}"
	path2 = "#{File.dirname __FILE__}/../#{type}/#{file}.#{ext}"
	if File.exist? path
		(type == "coffee" ? `coffee -c "#{path}"` : `scss -C "#{path}" "#{path2}"`) unless File.exist?(path2) and File.mtime(path2) > File.mtime(path)
		send_file path2
	end
	pass
end

#get request for recent docs, return JSON
get "/docs/recent" do
	JSON.generate getRecentDocs()
end

#doc requested by id, let's get it
get "/:id" do
	id = params[:id].strip.b BASE_62
	@doc = REDIS.zrangebyscore("docs", id, id)[0]
	if @doc
		@title = getTitle @doc
		@recentDocs = getRecentDocs()
		erb :index
	else
		redirect "/"
	end
end

#raw doc requested, we can do that
get "/:id/raw" do
	id = params[:id].strip.b BASE_62
	doc = REDIS.zrangebyscore("docs", id, id)[0]
	if doc
		content_type :txt
		doc
	else
		redirect "/"
	end
end

#send other random requests to the root
get "*" do
	redirect "/"
end

#there is only one post request possible in the program, so bind it to everything!
post "*" do
	response = {status: "missing param"}
	doc = params["doc"]
	if doc
		if doc.strip == ""
			response[:status] = "doc empty"
		else
			id = REDIS.zscore("docs", doc).to_i
			unless id != 0
				id = REDIS.zcard("docs")+1
				REDIS.zadd "docs", id, doc
			end
			response[:status] = id.b BASE_62
		end
	end
	JSON.generate response
end