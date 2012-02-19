
/*!
docdock main js
Casey Foster
caseyWebDev
caseywebdev.com
*/

(function() {
  var $;

  $ = jQuery;

  if (typeof docdock === "undefined" || docdock === null) {
    window.docdock = {
      init: function() {
        var k, v, _results;
        _results = [];
        for (k in docdock) {
          v = docdock[k];
          _results.push(typeof v.init === "function" ? v.init() : void 0);
        }
        return _results;
      },
      Ui: {
        xhr: {},
        init: function() {
          return $("#main").on("click", "#saveDoc", function() {
            var _base;
            if (typeof (_base = docdock.Ui.xhr).abort === "function") {
              _base.abort();
            }
            caseyWebDev.PopUp.show("Saving doc...");
            return docdock.Ui.xhr = $.post("/", {
              doc: $("#doc").val()
            }, function(data) {
              if (data.status === "doc empty") {
                caseyWebDev.PopUp.show("The doc is empty!", 1000);
                return $("#doc").val("").focus();
              } else {
                caseyWebDev.PopUp.show("Doc saved!");
                caseyWebDev.State.cache = [];
                return caseyWebDev.State.push("/" + data.status);
              }
            }, "json");
          });
        }
      },
      State: {
        init: function() {
          caseyWebDev.State.clear = function(url) {
            var _base;
            $.scrollTo(0);
            if (typeof (_base = docdock.Ui.xhr).abort === "function") {
              _base.abort();
            }
            return clearTimeout(docdock.State.loadingTimeout);
          };
          caseyWebDev.State.before = function(url) {
            return docdock.State.loadingTimeout = setTimeout(function() {
              return caseyWebDev.PopUp.show("Loading...");
            }, 200);
          };
          caseyWebDev.State.after = function(url) {
            clearTimeout(docdock.State.loadingTimeout);
            return caseyWebDev.PopUp.hide();
          };
          return caseyWebDev.State.parse = function(url) {
            document.title = caseyWebDev.State.cache[url].title;
            return $("#main").html(caseyWebDev.State.cache[url].html);
          };
        }
      }
    };
    $(docdock.init);
  }

}).call(this);
