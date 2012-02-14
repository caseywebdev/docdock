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
					caseyWebDev.PopUp.show("Saving doc...");
					docdock.xhr = $.post(
						"/",
						{
							doc: $("#doc").data("empty") ? "" : $("#doc").val()
						},
						function(data) {
							if (data.status == "doc empty") {
								caseyWebDev.PopUp.show("The doc is empty!", 1000);
								$("#doc").val("").focus();
							} else {
								caseyWebDev.PopUp.show("Doc saved!");
								caseyWebDev.State.cache = [];
								caseyWebDev.State.push("/"+data.status);
							}
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
				caseyWebDev.State.clear = function(url) {
					clearTimeout(docdock.State.loadingTimeout);
				};
				caseyWebDev.State.before = function(url) {
					docdock.State.loadingTimeout = setTimeout(function() {
		        		caseyWebDev.PopUp.show("Loading...");
		        	}, 200);
				};
				caseyWebDev.State.after = function(url) {
					clearTimeout(docdock.State.loadingTimeout);
			        caseyWebDev.PopUp.hide();
				};
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