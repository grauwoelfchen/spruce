// canvas
var ready = function() {
  // index
  $(".updated").each(function() {
    var updated = $(this)
      , time    = moment(updated.html());
    if (time.isValid()) {
      updated.html(time.fromNow());
    }
  });
  // editor
  $("#canvas")
    .autosize({
      callback: function(textarea) {
        $(textarea).scroll();
      }
    })
    .setNumber({
      activeLine: 1
    })
    .setCursorLine({
      cursorLineColor: "#F2F2F2"
    })
    .trigger("click");
};
$(document).ready(ready);
$(document).on("page:load", ready);
