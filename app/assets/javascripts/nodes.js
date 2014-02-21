// nodes
var applyNodeRelativeTime = function() {
  $(".nodes .updated").each(function() {
    var updated = $(this)
      , time    = moment.utc(updated.html());
    if (time.isValid()) {
      updated.html(time.local().fromNow());
    }
  });
};
var startup = function() {
  // index & show
  applyNodeRelativeTime();
  // new & creat & edit & update
  $("#node_name").focus();
};
$(document).ready(startup);
$(document).on("page:load", startup);
// expand & close
$(document).ajaxComplete(applyNodeRelativeTime);
