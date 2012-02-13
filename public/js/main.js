if (typeof docdock === "undefined" || docdock === null) {
	window.docdock = {
		init: function() {
			for (var i in docdock)
				if ((typeof docdock[i] == "object" || typeof docdock[i] == "function") && "init" in docdock[i] && typeof docdock[i].init == "function")
					docdock[i].init();
		},
		Ui: {
			xhr: {},
			init: function() {
				$("#main").on("click", "#saveDoc", function() {
					docdock.xhr = $.post(
						"/",
						{
							doc: $("#doc").data("empty") ? "" : $("#doc").val()
						},
						function(data) {
							if (data.status == "doc empty") {
								alert("The doc is empty!");
								$("#doc").val("").focus();
							} else
								caseyWebDev.State.cache = [];
								caseyWebDev.State.push("/"+data.status);
						},
						"json"
					);
				});
			},
			abortXhr: function() {
				if (docdock.xhr.abort != null)
					docdock.xhr.abort();
			}
		},
		State: {
			init: function() {
				caseyWebDev.State.parse = function(url) {
			    	document.title = caseyWebDev.State.cache[url].title;
					$("#main").html(caseyWebDev.State.cache[url].html);
		    		$($.browser.webkit ? document.body : document.documentElement).stop().animate({"scrollTop": 0});
				};
			}
		}
	};
	$(docdock.init);
}