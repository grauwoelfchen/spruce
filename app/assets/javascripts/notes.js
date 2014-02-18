// notes
var ready = function() {
  // index
  $(".notes .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().fromNow());
    }
  });
  // show
  $(".note .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().format("YYYY-MM-DD HH:mm:ss ZZ"));
    }
  });
  // new & create & edit & update
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
      cursorLineColor: "silver"
    })
    .trigger("click")
    .focus();
};
$(document).ready(ready);
$(document).on("page:load", ready);
