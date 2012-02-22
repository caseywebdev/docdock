###!
docdock main js
Casey Foster
caseyWebDev
caseywebdev.com
###
unless docdock?
	$ = jQuery
	window.docdock = class extends caseyWebDev
		@Ui: class
			@xhr: {}
			@load: ->
				$("#main").on "click", "#saveDoc", =>
					@xhr.abort?()
					docdock.PopUp.show "Saving doc..."
					@xhr = $.post("/"
						doc: $("#doc").val()
					, (data) ->
							if data.status is "doc empty"
								docdock.PopUp.show "The doc is empty!", 500
								$("#doc").val("").focus()
							else
								docdock.PopUp.show "Doc saved!", 500
								docdock.Poll.load()
								docdock.Poll.call()
								docdock.State.push "/"+data.status
					, "json"
					).error -> docdock.PopUp.show "Save error! Try again...", 500
		@Poll: class
			@xhr: {}
			@interval: 0
			@wait: 5
			@load: ->
				clearInterval @interval
				@interval = setInterval =>
					@call()
				, @wait*1000
			@call: ->
				@xhr.abort?()
				@xhr = $.getJSON("/docs/recent", null, (data) =>
					html = ""
					html += """<a href="/#{doc.id}" data-push-state>#{$.escapeHtml doc.doc}</a>""" for doc in data
					$("#recentDocs").html html if $("#recentDocs").html() isnt html
				).error ->
		@State: class extends caseyWebDev.State
			@loadingTimeout: 0
			@delay: 500
			@load: ->
				@updateCache location.href,
					title: document.title
					html: $("#pushState").html()
			@clear = (url) ->
				$.scrollTo()
				docdock.Ui.xhr.abort?()
				clearTimeout @loadingTimeout
			@before = (url) ->
				@loadingTimeout = setTimeout ->
					docdock.PopUp.show "Loading..."
				, @delay
			@after = (url) ->
				clearTimeout @loadingTimeout
				docdock.PopUp.hide()
			@parse = (url) ->
				document.title = @cache[url].title
				$("#pushState").html @cache[url].html
	docdock.init()