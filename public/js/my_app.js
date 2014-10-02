// DOCUMENT BEHAVIOR


$(document).ready(function () {

  $(".expand").click(function() {
    toggle_all();
  });

  $(".collapse").click(function() {
    toggle_all();
  });

  toggle_all = function() {
    $(".collapse").toggle();
    $(".expand").toggle();
    $(".hidden").toggle();
  };

});
