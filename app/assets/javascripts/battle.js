/**********************************************************/
/* Image upload preview                                   */
/**********************************************************/

function previewImageClick () {
  $('.current_picture').click(function() {
    $(this).attr('disabled', 'true');
    $(this).parent().find('.upload_picture').trigger('click');
  });
  $(".upload_picture").change(function(){
    readURL(this);
    $(this).parent().find('.current_picture').removeAttr('disabled');
  });
}

function readURL(input) {
  var url = input.value;
  var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();

  if (input.files && input.files[0] && (ext == "gif" || ext == "png" || ext == "jpeg" || ext == "jpg")) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $(input).parent().parent().parent().parent().removeClass('error');
      $(input).parent().find('.picture_preview_container').css('background', 'url(' + e.target.result + ')');
      $(input).parent().find('.picture_preview_container').css('background-size', 'cover');
      $(input).parent().find('.picture_preview_container').css('background-repeat', 'no-repeat');
      $(input).parent().find('.picture_preview_container').css('background-position', 'center center');
      $(input).parent().find('.picture_preview').show()
      $(input).parent().find('.existing_image').hide();
    }
    $(input).parent().find('.delete_picture').show();

    reader.readAsDataURL(input.files[0]);
  } else {
    $(input).parent().find('.upload_picture').val('');
    $(input).parent().find('.picture_preview').hide();
    $(input).parent().find('.existing_image').show();
    $(input).parent().parent().parent().parent().addClass('error');
  }
}

function deletePhoto () {
  $('.delete_picture').click(function() {
    $(this).hide();
    $(this).parent().find('.upload_picture').val('');
    $(this).parent().find('.picture_preview').hide();
    $(this).parent().find('.existing_image').show();
    $(this).parent().parent().parent().parent().removeClass('error');
  });
}

$(document).on('nested:fieldAdded', function(event){
  var field = event.field;

  previewImageClick();
  deletePhoto();
  field.find('.upload_picture').hide();
  field.find('.delete_picture').hide();
  field.find('.picture_preview').hide();
})


/**********************************************************/
/* Battle form validations                                */
/**********************************************************/

// override jquery validate plugin defaults
$.validator.setDefaults({
  highlight: function(element) {
    $(element).closest('.control-group').addClass('error');
  },
  unhighlight: function(element) {
    $(element).closest('.control-group').removeClass('error');
  },
  errorElement: 'span',
  errorClass: 'help-inline',
  errorPlacement: function(error, element) {
    if (element.parent('.input-append').length) {
      error.insertAfter(element.parent());
    } else {
      error.insertAfter(element);
    }
  }
});

function validateNumberOfOptions (battle_form) {
  if (battle_form.find(".options > div:visible").length < 2) {
    battle_form.find('#options_container').addClass('battle-options-error');
    battle_form.find('#battle-options-error').show();
    return false;
  } else if (battle_form.find(".options > div:visible").length > 6) {
    battle_form.find('#options_container').addClass('battle-options-error');
    battle_form.find('#battle-options-error').show();
    return false;
  } else {
    battle_form.find('#options_container').removeClass('battle-options-error');
    battle_form.find('#battle-options-error').hide();
    return true;
  }
}

function validateImagePresence (battle_form) {
  var ok = true;
  battle_form.find(".no_picture_container:visible").each(function(){
    $(this).closest('.option-box').addClass('error');
    ok = false;
  });
  return ok;
}

function validateInterval (input, error) {
  var min = input.data('min');
  var max = input.data('max');
  var val = input.val();
  if ((val >= min) && (val <= max)) {
    input.removeClass('error');
    error.hide();
    return true;
  }
  error.show();
  input.addClass('error');
  return false;
}

function validateDuration (battle_form) {
  var days = battle_form.find(".digit-days");
  var hours = battle_form.find(".digit-hours");
  var mins = battle_form.find(".digit-mins");
  var ret0, ret1, ret2, ret3;

  if ((days.val() > 0) || (hours.val() > 0) || (mins.val() > 0)) {
    battle_form.find(".battle-duration-error").hide();
    ret0 = true;
  }
  else {
    battle_form.find(".battle-duration-error").show();
    ret0 = false;
  }

  ret1 = validateInterval(days, battle_form.find(".battle-days-error"));
  ret2 = validateInterval(hours, battle_form.find(".battle-hours-error"));
  ret3 = validateInterval(mins, battle_form.find(".battle-mins-error"));

  return (ret0 && ret1 && ret2 && ret3);
}

function validateNewBattle () {
  $('.battle_form').validate({});
  $('.submit_form').click(function() {
    var ret0, ret1, ret2, ret3;
    var battle_form = $(this).closest('.battle_form');
    ret0 = validateImagePresence(battle_form);
    ret1 = validateNumberOfOptions(battle_form);
    ret2 = validateDuration(battle_form);
    ret3 = battle_form.valid();
    return (ret0 && ret1 && ret2 && ret3);
  });
}

$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into the form
  var field = event.field;
  validateNumberOfOptions(field.closest('.battle_form'));
})

$(document).on('nested:fieldRemoved', function(event){
  // this field was just removed the form
  var field = event.field;
  validateNumberOfOptions(field.closest('.battle_form'));
})


/**********************************************************/
/* Cancel form                                            */
/**********************************************************/

function removeForm (battle_form) {
  // if new:
  if(battle_form.parent().attr('id') === 'battle_form') {
    battle_form.parent().slideUp(350);
  }
  // else update:
  else {
    battle_form.parent().find('.battle:first').show();
    battle_form.parent().find('.battle_form:first').remove();
  }
}


/**********************************************************/
/* Infinite scrolling                                     */
/**********************************************************/

var onEndless = function() {
  var url;
  $(window).off('scroll', onEndless);
  url = $('.next_page').attr('href');
  $('.next_page').hide();
  if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 300) {
    return $.getScript(url, function() {
      return $(window).on('scroll', onEndless);
    });
  } else {
    return $(window).on('scroll', onEndless);
  }
};

$(window).on('scroll', onEndless);
jQuery(onEndless);


function avoidDuplicateBattle () {
  if ($(".last_page").length == 0) {
    $('#battle_index .battle_container:last').remove();
  }
  return;
}


/**********************************************************/
/* Battle countdown                                       */
/**********************************************************/

startBattleCounters = function(element) {
  $('[data-countdown]').each(function() {
    var $this = $(this);
    var finalDate = $(this).data('countdown');
    var day = $(this).data('day');
    var hour = $(this).data('hour');
    var min = $(this).data('min');
    var sec = $(this).data('sec');
    var finished = $(this).data('finished');

    $this.countdown(finalDate, function(event) {
      var format = '<span class="digit">%H</span>:<span class="digit">%M</span>:<span class="digit">%S</span>';
      var caption = '<span class="timer-range">' + hour + '%!H' + '</span>';
      caption = caption + '<span class="timer-range">' + min + '%!M' + '</span>';
      caption = caption + '<span class="timer-range">' + sec + '%!S' + '</span>';
      if (event.offset.days > 0) {
        format = '<span class="digit">%D</span>:' + format;
        caption = '<span class="timer-range">' + day + '%!D' + '</span>' + caption;
      }
      $(this).html(event.strftime(format + '<br></br>' + caption));

    })
    .on('finish.countdown', function(event) {
      $(this).html(finished);
      $(this).closest('.battle_container').find('.vote_picture_frame').removeClass('current_battle');
    });
  });
}

jQuery(startBattleCounters);


/**********************************************************/
/* Resize elements when inserting/removing nested element */
/**********************************************************/

function setOptionSizes (battle_form) {
  if (battle_form.find(".options > div:visible").length <= 1) {
    battle_form.find('.option-form-sizeable').addClass('span4');
    battle_form.find('.option-form-sizeable').removeClass('span3');
    battle_form.find('.option-form-sizeable').removeClass('span2');
    battle_form.find('.option-form-offsetable:first').addClass('offset2');
    battle_form.find('.option-form-offsetable:first').removeClass('offset1');
    battle_form.find('.option-form-offsetable:first').removeClass('offset0');
    return;
  } else if (battle_form.find(".options > div:visible").length == 2) {
    battle_form.find('.option-form-sizeable').addClass('span4');
    battle_form.find('.option-form-sizeable').removeClass('span3');
    battle_form.find('.option-form-sizeable').removeClass('span2');
    battle_form.find('.option-form-offsetable:first').addClass('offset0');
    battle_form.find('.option-form-offsetable:first').removeClass('offset1');
    battle_form.find('.option-form-offsetable:first').removeClass('offset2');
    return;
  } else if (battle_form.find(".options > div:visible").length == 3) {
    battle_form.find('.option-form-sizeable').addClass('span3');
    battle_form.find('.option-form-sizeable').removeClass('span4');
    battle_form.find('.option-form-sizeable').removeClass('span2');
    battle_form.find('.option-form-offsetable:first').addClass('offset0');
    battle_form.find('.option-form-offsetable:first').removeClass('offset1');
    battle_form.find('.option-form-offsetable:first').removeClass('offset2');
    battle_form.find('#add_new_option').addClass('btn-large');
    return;
  } else if (battle_form.find(".options > div:visible").length == 4) {
    battle_form.find('.option-form-sizeable').addClass('span2');
    battle_form.find('.option-form-sizeable').removeClass('span4');
    battle_form.find('.option-form-sizeable').removeClass('span3');
    battle_form.find('.option-form-offsetable:first').addClass('offset1');
    battle_form.find('.option-form-offsetable:first').removeClass('offset0');
    battle_form.find('.option-form-offsetable:first').removeClass('offset2');
    battle_form.find('#add_new_option').removeClass('btn-large');
    return;
  } else if (battle_form.find(".options > div:visible").length == 5) {
    battle_form.find(".new-option-outer").show();
    battle_form.find('.option-form-sizeable').addClass('span2');
    battle_form.find('.option-form-sizeable').removeClass('span4');
    battle_form.find('.option-form-sizeable').removeClass('span3');
    battle_form.find('.option-form-offsetable:first').addClass('offset0');
    battle_form.find('.option-form-offsetable:first').removeClass('offset1');
    battle_form.find('.option-form-offsetable:first').removeClass('offset2');
    battle_form.find('#add_new_option').removeClass('btn-large');
    return;
  } else {
    battle_form.find(".new-option-outer").hide();
    battle_form.find('.option-form-sizeable').addClass('span2');
    battle_form.find('.option-form-sizeable').removeClass('span4');
    battle_form.find('.option-form-sizeable').removeClass('span3');
    battle_form.find('.option-form-offsetable:first').addClass('offset0');
    battle_form.find('.option-form-offsetable:first').removeClass('offset1');
    battle_form.find('.option-form-offsetable:first').removeClass('offset2');
    battle_form.find('#add_new_option').removeClass('btn-large');
    return;
  }
}

$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into the form
  var field = event.field;
  setOptionSizes(field.closest('.battle_form'));
})

$(document).on('nested:fieldRemoved', function(event){
  // this field was just removed the form
  var field = event.field;
  setOptionSizes(field.closest('.battle_form'));
})


/**********************************************************/
/* Fixed battle title when scrolling the battle           */
/**********************************************************/

function moveScroller () {
  function move (battle) {
    offset = 0;
    if ($(window).width() >= 980) {
      offset = 66;
    }

    var battle_title_over = battle.find(".scroller-over");

    var scroll_position = $(window).scrollTop() + offset;
    var battle_top = battle_title_over.offset().top;
    var battle_bottom_final = battle.offset().top + battle.height() - 10;

    var battle_title = battle.find(".battle-title-row-container");
    var battle_title_container = battle.find(".battle-title-container");
    var battle_time_container = battle.find(".time-container");

    var battle_title_height = battle_title.height();
    var battle_bottom_initial = battle_bottom_final - battle_title_height;

    if (scroll_position <= battle_top) {
      battle_title.css({"top": ""});
      battle_title.removeClass('sticky');
      battle_title_container.removeClass('extra-margin');
      battle_time_container.removeClass('extra-time-margin');
      battle_title_over.css({"padding-top": ""});
    } else if (scroll_position > battle_top && scroll_position <= battle_bottom_initial) {
      battle_title.css({"top": ""});
      battle_title.addClass('sticky');
      battle_title_container.addClass('extra-margin');
      battle_time_container.addClass('extra-time-margin');
      battle_title_over.css({"padding-top": battle_title_height + "px"});
    } else if (scroll_position > battle_bottom_initial && scroll_position <= battle_bottom_final) {
      battle_title.css({"top": offset + (battle_bottom_initial - scroll_position) + "px"});
      battle_title.addClass('sticky');
      battle_title_container.addClass('extra-margin');
      battle_time_container.addClass('extra-time-margin');
      battle_title_over.css({"padding-top": battle_title_height + "px"});
    } else if (scroll_position > battle_bottom_final) {
      battle_title.css({"top": ""});
      battle_title.removeClass('sticky');
      battle_title_container.removeClass('extra-margin');
      battle_time_container.removeClass('extra-time-margin');
      battle_title_over.css({"padding-top": ""});
    }
  };

  function stickyEachBattleTitle () {
    var battle = $(".battle").each(function(){
      move($(this));
    });
  };

  $(window).scroll(stickyEachBattleTitle);
  stickyEachBattleTitle();

}

jQuery(moveScroller);


/**********************************************************/
/* Exhibit duration in days:hours:minutes                 */
/**********************************************************/

function setupDurationInput(battle_form) {
  var days_field = battle_form.find('.digit-days');
  var hours_field = battle_form.find('.digit-hours');
  var mins_field = battle_form.find('.digit-mins');
  var duration_field = battle_form.find('.battle-duration');

  function initializeDurationFields(duration_field, days_field, hours_field, mins_field) {
    left_mins = (parseInt(duration_field.val()) || 0) % 60;
    mins_field.val(left_mins);
    hours = Math.round(((parseInt(duration_field.val()) || 0) - left_mins) / 60);
    left_hours = hours % 24;
    hours_field.val(left_hours);
    days = Math.round((hours - left_hours) / 24);
    days_field.val(days);
  }

  function updateDuration() {
    var days = (parseInt(days_field.val()) || 0) * 24 * 60;
    var hours = (parseInt(hours_field.val()) || 0) * 60;
    var mins = (parseInt(mins_field.val()) || 0);
    duration_field.val(days + hours + mins);
    validateDuration(battle_form);
  }

  initializeDurationFields(duration_field, days_field, hours_field, mins_field);

  days_field.on("change, keyup", updateDuration);
  hours_field.on("change, keyup ", updateDuration);
  mins_field.on("change, keyup", updateDuration);
};


/**********************************************************/
/* Submit battle filter when filter is selected           */
/**********************************************************/

function autoFilterSubmit () {
  $('#battle-filter-select').on('change', function(){
    $('#battle-filter-btn').trigger('click');
  });
  $('#battle-filter-btn').hide();
}
jQuery(autoFilterSubmit);
