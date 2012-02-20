###!
docdock main js
Casey Foster
caseyWebDev
caseywebdev.com
###
$ = jQuery
unless docdock?
	window.docdock =
		init: ->
			for k, v of docdock
				v.init?()
		Ui:
			xhr: {}
			init: ->
				$("#main").on "click", "#saveDoc", ->
					docdock.Ui.xhr.abort?()
					caseyWebDev.PopUp.show "Saving doc..."
					docdock.Ui.xhr = $.post "/"
						doc: $("#doc").val()
					, (data) ->
							if data.status is "doc empty"
								caseyWebDev.PopUp.show "The doc is empty!", 1000
								$("#doc").val("").focus()
							else
								caseyWebDev.PopUp.show "Doc saved!"
								caseyWebDev.State.cache = []
								caseyWebDev.State.push "/"+data.status
					, "json"
		State:
			init: ->
				caseyWebDev.State.clear = (url) ->
					$.scrollTo()
					docdock.Ui.xhr.abort?()
					clearTimeout docdock.State.loadingTimeout
				caseyWebDev.State.before = (url) ->
					docdock.State.loadingTimeout = setTimeout ->
						caseyWebDev.PopUp.show "Loading..."
					, 200
				caseyWebDev.State.after = (url) ->
					clearTimeout docdock.State.loadingTimeout
					caseyWebDev.PopUp.hide()
				caseyWebDev.State.parse = (url) ->
					document.title = caseyWebDev.State.cache[url].title
					$("#main").html caseyWebDev.State.cache[url].html
	$ docdock.init