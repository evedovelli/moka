
selectablePictureBattle = function(selector) {
  $(selector + ' .vote_radio').css("display","none");
  $(selector + ' .vote_button').css("display","none");
  $(selector + ' .vote_picture_frame').on("click", function(){
    selectableOption($(this))
  });
  $(selector + ' .vote-icon').on("click", function(){
    selectableOption($(this))
  });
}

selectablePictureBattles = function() {
  $('.vote_radio').css("display","none");
  $('.vote_button').css("display","none");
  $('.vote_picture_frame').on("click", function(){
    selectableOption($(this))
  });
  $('.vote-icon').on("click", function(){
    selectableOption($(this))
  });
}

selectableOption = function(element) {
  // Option is not selectable if battle is not current
  if (!element.hasClass('current_battle')) {
    return;
  }

  battle_box = element.closest('.battle-box');
  option_outer_box = element.closest('.option-outer-box');

  // Remove previous selection
  battle_box.find('.outer_selected_picture').removeClass('outer_selected_picture');
  battle_box.find('.selected_picture').removeClass('selected_picture');
  battle_box.find('.option-box').removeClass('selected_box');
  battle_box.find('.vote-icon-check').removeClass('selected_icon');

  // Send vote
  option_outer_box.find('.vote_button').trigger('click');

  // Add new selection
  option_outer_box.find('.vote_picture_frame').addClass('outer_selected_picture');
  option_outer_box.find('.vote_picture').addClass('selected_picture');
  option_outer_box.find('.option-box').addClass('selected_box');
  option_outer_box.find('.vote-icon-check').addClass('selected_icon');
};

jQuery(selectablePictureBattles);
