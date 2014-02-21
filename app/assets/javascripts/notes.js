// notes
var applyNoteRelativeTime = function() {
  $(".notes .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().fromNow());
    }
  });
};
var startup = function() {
  // show
  applyNoteRelativeTime();
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
$(document).ready(startup);
$(document).on("page:load", startup);
