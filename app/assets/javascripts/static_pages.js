$('#homepage-info-modal').on('hidden.bs.modal', function () {
    $(this).removeData('bs.modal');
});

$(function() {
    $('.content-area').jScrollPane({
        horizontalGutter:5,
        verticalGutter:5,
        'showArrows': false
    });
});

$('.jspDrag').hide();
$('.jspTrack').hide();

$('.scrollable').hover(function(){
    $(this).find('.jspDrag').stop(true, true).fadeIn('slow');
    $(this).find('.jspTrack').stop(true, true).fadeIn('slow');},
                       function(){
                           $(this).find('.jspDrag').stop(true, true).fadeOut('slow');
                           $(this).find('.jspTrack').stop(true, true).fadeOut('slow');});
