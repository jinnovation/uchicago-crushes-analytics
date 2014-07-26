$(document).ready(function () {
    $(".row-link").click(function () {
        var url = $(this).attr("href");
        modalMain.modal({
            remote: url
        });
    });
});

