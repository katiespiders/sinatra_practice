// DOCUMENT BEHAVIOR


$(document).ready(function () {

  // CAN I NEST ANY OF THIS? HOW DO I MAKE IT TOGGLE ONE AT A TIME?
  $(".expand").click(function() {
    toggle_all();
  });

  $(".collapse").click(function() {
    toggle_all();
  });

  toggle_all = function() {
    $(".snippet").toggle();
    $(".collapse").toggle();
    $(".expand").toggle();
    $(".hidden").toggle();
  };

});
