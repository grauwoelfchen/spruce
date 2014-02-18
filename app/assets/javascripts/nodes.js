// nodes
var ready = function() {
  // index & show
  $(".nodes .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().fromNow());
    }
  });
  // new & creat & edit & update
  $("#node_name").focus();
};
$(document).ready(ready);
$(document).on("page:load", ready);
