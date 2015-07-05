
var selectablePicture;
var closeOverlayResults;

selectablePicture = function() {
  $('.vote_radio').css("display","none");
  $('.vote_picture').click(function() {
    $('.vote_picture').removeClass('selected_picture');
    $(this).addClass('selected_picture');
    $(this).closest('.vote_picture').find('.vote_radio').prop('checked', true);
  });
  $('.vote_picture_frame').click(function() {
    $('.vote_picture_frame').removeClass('outer_selected_picture');
    $(this).addClass('outer_selected_picture');
  });
};

closeOverlayResults = function() {
  $('#close_results').click(function() {
    $('#partial_results').css("display","none");
  });
}

$(document).ready(selectablePicture);

