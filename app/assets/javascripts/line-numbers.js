// numbers for textarea
(function($) {
  $.fn.lineNumbers = function(userOptions) {
    var options = $.extend({}, $.fn.lineNumbers.defaults, userOptions);
    // numbering
    var numbering = function(numbers, height, lineNo) {
      var diff = 4;
      if ((numbers.height() + 4 - height) < 0) {
        while ((numbers.height() + diff - height) < 0) {
          lineNo++;
          var klass = "line-no l-" + lineNo + ((lineNo === options.activeLine) ? " " + options.activeClass : "");
          numbers.append("<div class='" + klass + "'>" + lineNo + "</div>");
        }
      } else {
        while ((numbers.height() - (diff * 2) - height) > 0) {
          numbers.children("div.line-no.l-" + lineNo).remove();
          lineNo--;
        }
      }
      return lineNo;
    };
    return this.each(function() {
      var lineNo   = 1
        , textarea = $(this);
      // textarea
      textarea.attr("wrap", "off");
      textarea.css({ resize: "none" });
      textarea.wrap("<div class='line-numbers'></div>");
      var wrapper = textarea.parent().wrap("<div class='wrapper'></div>").parent();
      // lines
      wrapper.prepend("<div class='lines'></div>");
      var lines = wrapper.find(".lines");
      lines.height(textarea.height());
      // numbers
      lines.append( "<div class='numbers'></div>" );
      var numbers = lines.find(".numbers");
      // first numbering
      lineNo = numbering(numbers, textarea.height(), 0);
      // goto active
      if (options.activeLine != -1 && !isNaN(options.activeLine)) {
        var fontSize = parseInt(textarea.height() / (lineNo - 2))
          , position = parseInt(fontSize * options.activeLine) - (textarea.height() / 2);
        textarea[0].scrollTop = position;
      }
      var callback = function(tn) {
        var textarea  = $(this);
        lineNo = numbering(numbers, textarea.height(), lineNo);
      };
      // scroll
      textarea.scroll(callback);
      // resize
      //textarea.resize(callback);
    });
  };
  // default
  $.fn.lineNumbers.defaults = {
    activeLine:  -1
  , activeClass: "active"
  };
})(jQuery);
