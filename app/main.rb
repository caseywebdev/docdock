require "sinatra"
require "redis"
require "json"
require_relative "anyBase"

configure do
	#set the base string we'll use for converting from base 10
	BASE_62 = ("0".."9").to_a.join("")+("a".."z").to_a.join("")+("A".."Z").to_a.join("")
	#define our Redis instance
	REDIS = Redis.new
	REDIS.select 0
	REDIS.setnx "_id", 0
	#set the default page title, that is, if @title is never set
	DEFAULT_TITLE = "docdock | The Dock for Docs"
	#set the title appendage so that the final title looks like @title+TITLE_APPENDAGE
	TITLE_APPENDAGE = " | docdock"
	#number of recent docs to show
	RECENT_DOCS = 10
	set :public_folder, File.dirname(__FILE__)+"/../public"
end

get "/*" do
	if params[:splat][0] != ""
		@id = params[:splat][0]
		if REDIS.exists @id
			@doc = REDIS.get @id
		else
			redirect "/"
		end
	end
	lastId = REDIS.get("_id").to_i
	@recentDocs = []
	RECENT_DOCS.times do |i|
		id = lastId-i
		if id > 0
			idBase62 = id.b BASE_62
			@recentDocs << { id: idBase62, doc: REDIS.get(idBase62) }
		else
			break
		end
	end
	erb :index
end

post "*" do
	response = {status: "missing param"}
	if params["doc"]
		if params["doc"].strip == ""
			response["status"] = "doc empty"
		else
			id = REDIS.incr("_id").b BASE_62
			REDIS.set id, params["doc"]
			response["status"] = id
		end
	end
	JSON.generate response
end