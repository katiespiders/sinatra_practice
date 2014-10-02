// DOCUMENT BEHAVIOR


$(document).ready(function () {

    $(".expand").click(function () {
        $(".content").toggle();
        console.log("hi");
    });

    $(".content").click(function () {
        $(this).toggle();
    });

});
