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
    if(element.parent('.input-append').length) {
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

function validateNewBattle () {
  $('.battle_form').validate({});
  $('.submit_form').click(function() {
    var ret0, ret1, ret2;
    var battle_form = $(this).closest('.battle_form');
    ret0 = validateImagePresence(battle_form);
    ret1 = validateNumberOfOptions(battle_form);
    ret2 = battle_form.valid();
    return (ret0 && ret1 && ret2);
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
  if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 500) {
    return $.getScript(url, function() {
      return $(window).on('scroll', onEndless);
    });
  } else {
    return $(window).on('scroll', onEndless);
  }
};

$(window).on('scroll', onEndless);


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

