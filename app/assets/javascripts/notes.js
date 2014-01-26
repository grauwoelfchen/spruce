// canvas
var ready = function () {
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
