$(document).ready(function () {

    $(".modal-link").click(function () {
        var url = $(this).attr("href");
        window.location = url;
    })
});

