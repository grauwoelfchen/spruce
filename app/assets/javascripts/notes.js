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

  // new
  $("#canvas").autosize({
    callback: function(textarea) {
      $(textarea).scroll();
    }
  });
  $("#canvas").lineNumbers({
    activeLine: 1
  });

};
$(document).ready(ready);
$(document).on("page:load", ready);
