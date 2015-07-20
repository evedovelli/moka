
selectablePictureBattle = function(selector) {
  $(selector + ' .vote_radio').css("display","none");
  $(selector + ' .vote_button').css("display","none");
  $(selector + ' .vote_picture_frame').on("click", function(){
    selectablePicture($(this))
  });
}

selectablePictureBattles = function() {
  $('.vote_radio').css("display","none");
  $('.vote_button').css("display","none");
  $('.vote_picture_frame').on("click", function(){
    selectablePicture($(this))
  });
}

selectablePicture = function(element) {
  // Option is not selectable if battle is not current
  if (!element.hasClass('current_battle')) {
    return;
  }

  // Remove previous selection
  element.closest('.battle-box').find('.outer_selected_picture').removeClass('outer_selected_picture');
  element.closest('.battle-box').find('.selected_picture').removeClass('selected_picture');
  element.closest('.battle-box').find('.option-box').removeClass('selected_box');

  // Add new selection
  element.addClass('outer_selected_picture');
  element.find('.vote_picture').addClass('selected_picture');
  element.find('.option-box').addClass('selected_box');

  // Check box
  radio_button = element.find('.vote_radio');
  radio_button.prop('checked', true);
  radio_value = radio_button.val();

  // Send vote
  element.closest('.new_vote').find('.vote_button').trigger('click');
};

jQuery(selectablePictureBattles);
