// nodes
var ready = function() {
  // index
  $(".nodes .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().fromNow());
    }
  });
  // show
  $(".nodes .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().format("YYYY-MM-DD HH:mm:ss ZZ"));
    }
  });
};
$(document).ready(ready);
$(document).on("page:load", ready);
